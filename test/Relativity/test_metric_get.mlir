module {
  func.func @main(%x: vector<4xf64>) -> tensor<4x4xf64> {
    %g = "relativity.metric.get"(%x)
         { name = "schwarzschild_ks", params = { M = 1.0 : f64 } }
         : (vector<4xf64>) -> tensor<4x4xf64>
    return %g : tensor<4x4xf64>
  }
}
