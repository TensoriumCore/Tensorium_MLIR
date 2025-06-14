module {
  func.func @schwarzschild(%t: f64, %r: f64, %theta: f64, %phi: f64) -> f64 {
    %c0 = arith.constant 1.0 : f64
    %c1 = arith.constant 4.0 : f64
    %c2 = arith.constant 1.0 : f64
    %x3 = arith.divf %c2, %r : f64
    %c4 = arith.constant 1.0 : f64
    %x5 = arith.mulf %c4, %r : f64
    %c6 = arith.constant -2.0 : f64
    %x7 = arith.mulf %c6, %c0 : f64
    %x8 = arith.addf %x5, %x7 : f64
    %c9 = arith.constant 1.0 : f64
    %x10 = arith.divf %c9, %x8 : f64
    %c11 = arith.constant -1.0 : f64
    %x12 = arith.mulf %c11, %c0 : f64
    %x13 = arith.addf %r, %x12 : f64
    %x14 = arith.mulf %c1, %c0 : f64
    %x15 = arith.mulf %x14, %x3 : f64
    %x16 = arith.mulf %x15, %x10 : f64
    %x17 = arith.mulf %x16, %x13 : f64
    %c18 = arith.constant 0.0 : f64
    %result = arith.addf %x17, %c18 : f64
    return %result : f64
  }
}