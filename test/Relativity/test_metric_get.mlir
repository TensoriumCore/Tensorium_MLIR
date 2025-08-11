// test_metric_get_in_func.mlir
module {
  func.func @main() -> tensor<4x4xf64> {
    %x = arith.constant dense<[1.0, 2.0, 3.0, 4.0]> : vector<4xf64>
    %g = "relativity.metric.get"(%x)
         { name = "minkowski", params = {} }
         : (vector<4xf64>) -> tensor<4x4xf64>
    return %g : tensor<4x4xf64>
  }
}
