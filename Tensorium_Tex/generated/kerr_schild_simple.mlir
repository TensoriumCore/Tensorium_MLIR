module {
  func.func @kerr_schild_simple(%t: f64, %r: f64, %theta: f64, %phi: f64, %m: f64, %a: f64) -> f64 {
    %c0 = arith.constant 1.0 : f64
    %c1 = arith.constant 1.0 : f64
    %c2 = arith.constant 1.0 : f64
    %c3 = arith.constant 1.0 : f64
    %c4 = arith.constant 1.0 : f64
    %c5 = arith.constant 1.0 : f64
    %c6 = arith.constant 2.0 : f64
    %c7 = arith.constant 1.0 : f64
    %x8 = arith.divf %c7, %c0 : f64
    %c9 = arith.constant 1.0 : f64
    %x10 = arith.divf %c9, %c1 : f64
    %x11 = arith.mulf %c0, %c1 : f64
    %x12 = arith.mulf %r, %c2 : f64
    %x13 = arith.mulf %a, %c3 : f64
    %x14 = arith.mulf %r, %c4 : f64
    %x15 = arith.mulf %r, %c3 : f64
    %c16 = arith.constant -1.0 : f64
    %x17 = arith.mulf %c16, %a : f64
    %x18 = arith.mulf %x17, %c4 : f64
    %x19 = arith.addf %x13, %x14 : f64
    %x20 = arith.addf %x19, %x15 : f64
    %x21 = arith.addf %x20, %x18 : f64
    %x22 = arith.mulf %r, %x21 : f64
    %x23 = arith.mulf %c2, %c5 : f64
    %x24 = arith.addf %x12, %x22 : f64
    %x25 = arith.addf %x24, %x23 : f64
    %x26 = arith.mulf %x25, %x25 : f64
    %x27 = arith.mulf %m, %r : f64
    %x28 = arith.mulf %x27, %x26 : f64
    %x29 = arith.addf %x11, %x28 : f64
    %x30 = arith.mulf %c6, %x8 : f64
    %x31 = arith.mulf %x30, %x10 : f64
    %x32 = arith.mulf %x31, %x29 : f64
    %c33 = arith.constant 0.0 : f64
    %result = arith.addf %x32, %c33 : f64
    return %result : f64
  }
}