
module {
  func.func @SchwarzschildSpatial(%x: vector<4xf64>) -> tensor<3x3xf64> {
    %g = relativity.metric.get "schwarzschild_ks" {params = {M = 1.000000e+00 : f64}} %x
         : vector<4xf64> -> tensor<4x4xf64>
    %gamma = relativity.metric.spatial %g
         : tensor<4x4xf64> -> tensor<3x3xf64>
    return %gamma : tensor<3x3xf64>
  }

  func.func @DetInvGamma(%x: vector<4xf64>) -> (f64, tensor<3x3xf64>) {
    %gamma = call @SchwarzschildSpatial(%x)
            : (vector<4xf64>) -> tensor<3x3xf64>

    // <<< Utilise la forme générique >>>
    %det = "relativity.det3x3"(%gamma)
           : (tensor<3x3xf64>) -> f64
    %inv = "relativity.inv3x3"(%gamma)
           : (tensor<3x3xf64>) -> tensor<3x3xf64>

    return %det, %inv : f64, tensor<3x3xf64>
  }
}

