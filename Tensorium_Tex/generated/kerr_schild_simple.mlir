module {
  func.func @kerr_schild_simple(%t: f64, %r: f64, %theta: f64, %phi: f64) -> f64 {
    %c0 = arith.constant 1.0 : f64
    %c1 = arith.constant 1.0 : f64
    %c2 = arith.constant 1.0 : f64
    %c3 = arith.constant 1.0 : f64
    %c4 = arith.constant 1.0 : f64
    %c5 = arith.constant 1.0 : f64
    %c6 = arith.constant 1.0 : f64
    %c7 = arith.constant 1.0 : f64
    %c8 = arith.constant 1.0 : f64
    %c9 = arith.constant 1.0 : f64
    %x10 = arith.divf %c9, %c0 : f64
    %c11 = arith.constant 0.25 : f64
    %x12 = arith.mulf %c11, %c2 : f64
    %x13 = arith.addf %c1, %x12 : f64
    %c14 = arith.constant 1.0 : f64
    %x15 = arith.divf %c14, %x13 : f64
    %c16 = arith.constant 0.5 : f64
    %x17 = arith.mulf %c16, %c2 : f64
    %c18 = arith.constant 2.0 : f64
    %x19 = arith.mulf %c18, %c1 : f64
    %x20 = arith.addf %x17, %x19 : f64
    %x21 = arith.mulf %c0, %x20 : f64
    %c22 = arith.constant 2.0 : f64
    %c23 = arith.constant 0.5 : f64
    %x24 = arith.mulf %c23, %c4 : f64
    %c25 = arith.constant -0.5 : f64
    %x26 = arith.mulf %c25, %c5 : f64
    %x27 = arith.mulf %c5, %c6 : f64
    %x28 = arith.mulf %c6, %c4 : f64
    %x29 = arith.addf %x24, %x26 : f64
    %x30 = arith.addf %x29, %x27 : f64
    %x31 = arith.addf %x30, %x28 : f64
    %x32 = arith.mulf %r, %x31 : f64
    %x33 = arith.mulf %c7, %c6 : f64
    %c34 = arith.constant 1.0 : f64
    %x35 = arith.mulf %c34, %c7 : f64
    %x36 = arith.mulf %x35, %c8 : f64
    %x37 = arith.addf %x32, %x33 : f64
    %x38 = arith.addf %x37, %x36 : f64
    %x39 = arith.mulf %x38, %x38 : f64
    %x40 = arith.mulf %c22, %c3 : f64
    %x41 = arith.mulf %x40, %r : f64
    %x42 = arith.mulf %x41, %x39 : f64
    %x43 = arith.addf %x21, %x42 : f64
    %x44 = arith.mulf %x10, %x15 : f64
    %x45 = arith.mulf %x44, %x43 : f64
    %c46 = arith.constant 0.0 : f64
    %result = arith.addf %x45, %c46 : f64
    return %result : f64
  }
}