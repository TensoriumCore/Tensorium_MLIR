module {
  func.func @GridMetric1D(%coords: tensor<10x4xf64>) 
    -> (tensor<10xf64>, tensor<10x3xf64>, tensor<10x3x3xf64>) {
    
    %alpha, %beta, %gamma = relativity.metric.get "schwarzschild_ks" 
        params = {M = 1.0 : f64} 
        (%coords) : tensor<10x4xf64> -> (tensor<10xf64>, tensor<10x3xf64>, tensor<10x3x3xf64>)
    
    return %alpha, %beta, %gamma : tensor<10xf64>, tensor<10x3xf64>, tensor<10x3x3xf64>
  }

  func.func @GridMetric2D(%coords: tensor<64x64x4xf64>) 
    -> (tensor<64x64xf64>, tensor<64x64x3xf64>, tensor<64x64x3x3xf64>) {
    
    %alpha, %beta, %gamma = relativity.metric.get "schwarzschild_ks" 
        params = {M = 2.0 : f64} 
        (%coords) : tensor<64x64x4xf64> -> (tensor<64x64xf64>, tensor<64x64x3xf64>, tensor<64x64x3x3xf64>)
    
    return %alpha, %beta, %gamma : tensor<64x64xf64>, tensor<64x64x3xf64>, tensor<64x64x3x3xf64>
  }

  func.func @GridMetric3D(%coords: tensor<5x5x5x4xf64>) 
    -> (tensor<5x5x5xf64>, tensor<5x5x5x3xf64>, tensor<5x5x5x3x3xf64>) {
    
    %alpha, %beta, %gamma = relativity.metric.get "schwarzschild_ks" 
        params = {M = 1.5 : f64} 
        (%coords) : tensor<5x5x5x4xf64> -> (tensor<5x5x5xf64>, tensor<5x5x5x3xf64>, tensor<5x5x5x3x3xf64>)
    
    return %alpha, %beta, %gamma : tensor<5x5x5xf64>, tensor<5x5x5x3xf64>, tensor<5x5x5x3x3xf64>
  }
}
