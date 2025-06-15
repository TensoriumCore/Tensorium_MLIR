module {
  func.func @minkowski(%t: f64, %r: f64, %theta: f64, %phi: f64, %m: f64, %a: f64) -> f64 {
    %c0 = arith.constant 0.0 : f64
    %c1 = arith.constant 0.0 : f64
    %result = arith.addf %c0, %c1 : f64
    return %result : f64
  }
}