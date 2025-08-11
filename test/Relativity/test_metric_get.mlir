module {
  %x = arith.constant dense<[1.0, 2.0, 3.0, 4.0]> : vector<4xf64>

  %g = "relativity.metric.get"(%x)
       { name = "minkowski", params = {} }
       : (vector<4xf64>) -> tensor<4x4xf64>

  func.func @main(%arg0: tensor<4x4xf64>) {
    return
  }
}
