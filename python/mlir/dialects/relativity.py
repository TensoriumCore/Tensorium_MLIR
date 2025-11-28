from mlir.ir import Context, Module
from mlir.passmanager import PassManager
from mlir import ir as _ir

from mlir.dialects import _relativity_ops as _rel_c_ext

from ._relativity_ops_gen import *


def register_passes():
    _rel_c_ext.register_passes()


def register_dialect(context: _ir.Context, load: bool = True):
    _rel_c_ext.register_dialect(context._CAPIPtr, load)


def lower_module(module: Module) -> Module:
    pipeline = """
builtin.module(
  rel-expand-metric,
  convert-tensor-to-linalg,
  one-shot-bufferize{bufferize-function-boundaries},
  convert-linalg-to-loops,
  convert-bufferization-to-memref,
  expand-strided-metadata,
  lower-affine,
  convert-scf-to-cf,
  finalize-memref-to-llvm,
  func.func(llvm-request-c-wrappers),
  convert-func-to-llvm,
  convert-cf-to-llvm,
  convert-vector-to-llvm,
  convert-math-to-llvm,
  convert-arith-to-llvm,
  reconcile-unrealized-casts
)
"""
    pm = PassManager.parse(pipeline)
    pm.run(module.operation)
    return module


__all__ = [
    *[name for name in globals().keys()
      if not name.startswith("_") and name not in ("register_dialect", "register_passes")],
    "register_dialect",
    "register_passes",
    "lower_module",
]
