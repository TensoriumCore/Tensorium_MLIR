module {
  func.func @flrw_flat(%t: f64, %r: f64, %theta: f64, %phi: f64) -> f64 {
    %c0 = arith.constant -0.75 : f64
    %c1 = arith.constant 0.0 : f64
    %result = arith.addf %c0, %c1 : f64
    return %result : f64
  }
}