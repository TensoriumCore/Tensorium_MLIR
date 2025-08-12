module {
  // Base: construit g_{μν}(x) pour Schwarzschild en coordonnées Kerr–Schild.
  func.func @Schwarzschild(%x: vector<4xf64>) -> tensor<4x4xf64> {
    %g = relativity.metric.get "schwarzschild_ks" {params = {M = 1.0 : f64}} %x
         : vector<4xf64> -> tensor<4x4xf64>
    return %g : tensor<4x4xf64>
  }

  // Test extraction γ_ij = g_{ij} (i,j=1..3) via metric.spatial.
  func.func @SchwarzschildSpatial(%x: vector<4xf64>) -> tensor<3x3xf64> {
    %g = relativity.metric.get "schwarzschild_ks" {params = {M = 1.0 : f64}} %x
         : vector<4xf64> -> tensor<4x4xf64>
    %gamma = relativity.metric.spatial %g
         : tensor<4x4xf64> -> tensor<3x3xf64>
    return %gamma : tensor<3x3xf64>
  }
}
