module {
  func.func @schwarzschild(%t: f64, %r: f64, %theta: f64, %phi: f64, %m: f64, %a: f64) -> f64 {
    %c0 = arith.constant 4.0 : f64
    %c1 = arith.constant 1.0 : f64
    %x2 = arith.divf %c1, %r : f64
    %c3 = arith.constant 1.0 : f64
    %x4 = arith.mulf %c3, %r : f64
    %c5 = arith.constant -2.0 : f64
    %x6 = arith.mulf %c5, %m : f64
    %x7 = arith.addf %x4, %x6 : f64
    %c8 = arith.constant 1.0 : f64
    %x9 = arith.divf %c8, %x7 : f64
    %c10 = arith.constant -1.0 : f64
    %x11 = arith.mulf %c10, %m : f64
    %x12 = arith.addf %r, %x11 : f64
    %x13 = arith.mulf %c0, %m : f64
    %x14 = arith.mulf %x13, %x2 : f64
    %x15 = arith.mulf %x14, %x9 : f64
    %x16 = arith.mulf %x15, %x12 : f64
    %c17 = arith.constant 0.0 : f64
    %result = arith.addf %x16, %c17 : f64
    return %result : f64
  }
}