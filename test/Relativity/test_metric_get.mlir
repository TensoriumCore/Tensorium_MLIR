
module {
  func.func @Schwarzschild(%x: vector<4xf64>)
      -> (f64, tensor<3xf64>, tensor<3x3xf64>) {
    %alpha, %beta, %gamma =
      relativity.metric.get "schwarzschild_ks"
        params = { M = 1.0 : f64 }
        (%x)
        : vector<4xf64>
          -> (f64, tensor<3xf64>, tensor<3x3xf64>)
    return %alpha, %beta, %gamma :
      f64, tensor<3xf64>, tensor<3x3xf64>
  }
}

