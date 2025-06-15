module {
  func.func @flrw_flat(%t: f64, %r: f64, %theta: f64, %phi: f64, %m: f64, %a: f64) -> f64 {
    %c0 = arith.constant -1.0 : f64
    %c1 = arith.constant 1.0 : f64
    %x2 = arith.mulf %a, %a : f64
    %x3 = arith.mulf %c1, %x2 : f64
    %x4 = arith.addf %c0, %x3 : f64
    %c5 = arith.constant 0.0 : f64
    %result = arith.addf %x4, %c5 : f64
    return %result : f64
  }
}