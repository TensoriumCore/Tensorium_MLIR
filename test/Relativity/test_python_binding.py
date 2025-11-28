
from mlir.ir import *
from mlir.passmanager import PassManager
from mlir.dialects import relativity



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
with Context() as ctx:
    relativity.register_dialect(ctx)
    relativity.register_passes()

    module = Module.parse(r"""
      module {
        func.func @GridMetric1D(%coords: tensor<10x4xf64>)
          -> (tensor<10xf64>, tensor<10x3xf64>, tensor<10x3x3xf64>) {
          %alpha, %beta, %gamma =
            relativity.metric.get "schwarzschild_ks"
              params = {M = 1.0 : f64}(%coords)
              : tensor<10x4xf64>
                -> (tensor<10xf64>, tensor<10x3xf64>, tensor<10x3x3xf64>)
          return %alpha, %beta, %gamma :
            tensor<10xf64>, tensor<10x3xf64>, tensor<10x3x3xf64>
        }

        func.func @GridMetric2D(%coords: tensor<64x64x4xf64>)
          -> (tensor<64x64xf64>, tensor<64x64x3xf64>, tensor<64x64x3x3xf64>) {
          %alpha, %beta, %gamma =
            relativity.metric.get "schwarzschild_ks"
              params = {M = 2.0 : f64}(%coords)
              : tensor<64x64x4xf64>
                -> (tensor<64x64xf64>, tensor<64x64x3xf64>, tensor<64x64x3x3xf64>)
          return %alpha, %beta, %gamma :
            tensor<64x64xf64>, tensor<64x64x3xf64>, tensor<64x64x3x3xf64>
        }

        func.func @GridMetric3D(%coords: tensor<5x5x5x4xf64>)
          -> (tensor<5x5x5xf64>, tensor<5x5x5x3xf64>, tensor<5x5x5x3x3xf64>) {
          %alpha, %beta, %gamma =
            relativity.metric.get "schwarzschild_ks"
              params = {M = 1.5 : f64}(%coords)
              : tensor<5x5x5x4xf64>
                -> (tensor<5x5x5xf64>, tensor<5x5x5x3xf64>, tensor<5x5x5x3x3xf64>)
          return %alpha, %beta, %gamma :
            tensor<5x5x5xf64>, tensor<5x5x5x3xf64>, tensor<5x5x5x3x3xf64>
        }
      }
    """)


    pm = PassManager.parse(pipeline)
    pm.run(module.operation)


    print(module)
