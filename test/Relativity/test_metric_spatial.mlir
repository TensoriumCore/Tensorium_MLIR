module {
  // Accepte 4 scalaires au lieu d'un vecteur pour garantir la compatibilité C++
  func.func @SchwarzschildSpatial(%t: f64, %x: f64, %y: f64, %z: f64) -> tensor<3x3xf64> {
    
    // UTILISATION DE VECTOR.FROM_ELEMENTS
    // C'est beaucoup plus sûr et propre que la chaîne splat/insert
    %vec_input = vector.from_elements %t, %x, %y, %z : vector<4xf64>

    %g = relativity.metric.get "schwarzschild_ks" {params = {M = 1.0 : f64}} %vec_input
         : vector<4xf64> -> tensor<4x4xf64>
    
    %gamma = relativity.metric.spatial %g
         : tensor<4x4xf64> -> tensor<3x3xf64>
    
    return %gamma : tensor<3x3xf64>
  }

  func.func @DetInvGamma(%t: f64, %x: f64, %y: f64, %z: f64) -> (f64, tensor<3x3xf64>) {
    // Appel interne avec les scalaires
    %gamma = call @SchwarzschildSpatial(%t, %x, %y, %z)
             : (f64, f64, f64, f64) -> tensor<3x3xf64>

    %det = "relativity.det3x3"(%gamma) : (tensor<3x3xf64>) -> f64
    %inv = "relativity.inv3x3"(%gamma) : (tensor<3x3xf64>) -> tensor<3x3xf64>

    return %det, %inv : f64, tensor<3x3xf64>
  }
}
