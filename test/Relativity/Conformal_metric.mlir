
module {
  func.func @main(%g: tensor<3x3xf64>, %chi: f64) -> tensor<3x3xf64> {
    %cg = relativity.create_conformal_metric %g, %chi : tensor<3x3xf64>, f64 -> tensor<3x3xf64>
    return %cg : tensor<3x3xf64>
  }
}
