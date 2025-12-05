import os
import subprocess
import tempfile
from mlir.ir import Module
from mlir.passmanager import PassManager

MLIR_TRANSLATE = "mlir-translate"
CLANG = "clang"


class Compiler:
    def __init__(self):
        pass

    def _optimize(self, module: Module):
        """Applique ton pipeline de passes MLIR."""
        pipeline = """
    builtin.module(
        rel-expand-metric,
        convert-tensor-to-linalg,
        one-shot-bufferize{bufferize-function-boundaries},
        -convert-linalg-to-openmp, 
        -convert-linalg-to-vector,
        -vector-transfer-op-optimization,
        -vector-unroll-vector-transfers,
        -convert-linalg-to-loops,
        -convert-openmp-to-llvm,
        -convert-vector-to-llvm,
        -lower-affine,
        -convert-scf-to-cf,
        -finalize-memref-to-llvm,
        -func.func(llvm-request-c-wrappers),
        -convert-func-to-llvm,
        -convert-cf-to-llvm,
        -convert-math-to-llvm,
        -convert-arith-to-llvm,
        -reconcile-unrealized-casts
    )
    """
        pm = PassManager.parse(pipeline)
        pm.run(module.operation)
        return module

    def compile_to_shared_lib(self, module: Module, output_path: str = "kernel.so"):
        self._optimize(module)

        mlir_source = str(module)

        tr_proc = subprocess.Popen(
            [MLIR_TRANSLATE, "--mlir-to-llvmir"],
            stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
            text=True
        )
        llvm_ir, err = tr_proc.communicate(input=mlir_source)
        if tr_proc.returncode != 0:
            raise RuntimeError(f"Erreur mlir-translate:\n{err}")

        clang_cmd = [CLANG, "-x", "ir", "-", "-shared",
                     "-o", output_path, "-O3", "-fPIC"]

        cl_proc = subprocess.Popen(
            clang_cmd,
            stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
            text=True
        )
        _, err = cl_proc.communicate(input=llvm_ir)
        if cl_proc.returncode != 0:
            raise RuntimeError(f"Clang:\n{err}")

        return os.path.abspath(output_path)
