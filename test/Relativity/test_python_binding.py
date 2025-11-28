from mlir.ir import *

from mlir.dialects import relativity
from mlir.dialects.relativity import lower_module


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
        }
    """)

    lowered = lower_module(module)
    print(lowered)
