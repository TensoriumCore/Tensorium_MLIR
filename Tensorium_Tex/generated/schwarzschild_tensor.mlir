module {
  func.func @schwarzschild_tensor(%t: f64, %r: f64, %theta: f64, %phi: f64, %m: f64, %a: f64) -> memref<4x4xf64> {
    %buf = memref.alloc() : memref<4x4xf64>
    %c0_f64 = arith.constant 0.0 : f64
    %x1 = arith.negf %r : f64
    %c2 = arith.constant 2.0 : f64
    %x3 = arith.mulf %c2, %m : f64
    %x4 = arith.addf %x1, %x3 : f64
    %x5 = arith.divf %x4, %r : f64
    %g00 = arith.addf %x5, %c0_f64 : f64
    %c0_idx = arith.constant 0 : index
    memref.store %g00, %buf[%c0_idx, %c0_idx] : memref<4x4xf64>
    %c6 = arith.constant 0.0 : f64
    %g01 = arith.addf %c6, %c0_f64 : f64
    %c1_idx = arith.constant 1 : index
    memref.store %g01, %buf[%c0_idx, %c1_idx] : memref<4x4xf64>
    %c7 = arith.constant 0.0 : f64
    %g02 = arith.addf %c7, %c0_f64 : f64
    %c2_idx = arith.constant 2 : index
    memref.store %g02, %buf[%c0_idx, %c2_idx] : memref<4x4xf64>
    %c8 = arith.constant 0.0 : f64
    %g03 = arith.addf %c8, %c0_f64 : f64
    %c3_idx = arith.constant 3 : index
    memref.store %g03, %buf[%c0_idx, %c3_idx] : memref<4x4xf64>
    %c9 = arith.constant 0.0 : f64
    %g10 = arith.addf %c9, %c0_f64 : f64
    memref.store %g10, %buf[%c1_idx, %c0_idx] : memref<4x4xf64>
    %c10 = arith.constant -2.0 : f64
    %x11 = arith.mulf %c10, %m : f64
    %x12 = arith.addf %r, %x11 : f64
    %x13 = arith.divf %r, %x12 : f64
    %g11 = arith.addf %x13, %c0_f64 : f64
    memref.store %g11, %buf[%c1_idx, %c1_idx] : memref<4x4xf64>
    %c14 = arith.constant 0.0 : f64
    %g12 = arith.addf %c14, %c0_f64 : f64
    memref.store %g12, %buf[%c1_idx, %c2_idx] : memref<4x4xf64>
    %c15 = arith.constant 0.0 : f64
    %g13 = arith.addf %c15, %c0_f64 : f64
    memref.store %g13, %buf[%c1_idx, %c3_idx] : memref<4x4xf64>
    %c16 = arith.constant 0.0 : f64
    %g20 = arith.addf %c16, %c0_f64 : f64
    memref.store %g20, %buf[%c2_idx, %c0_idx] : memref<4x4xf64>
    %c17 = arith.constant 0.0 : f64
    %g21 = arith.addf %c17, %c0_f64 : f64
    memref.store %g21, %buf[%c2_idx, %c1_idx] : memref<4x4xf64>
    %x18 = arith.mulf %r, %r : f64
    %g22 = arith.addf %x18, %c0_f64 : f64
    memref.store %g22, %buf[%c2_idx, %c2_idx] : memref<4x4xf64>
    %c19 = arith.constant 0.0 : f64
    %g23 = arith.addf %c19, %c0_f64 : f64
    memref.store %g23, %buf[%c2_idx, %c3_idx] : memref<4x4xf64>
    %c20 = arith.constant 0.0 : f64
    %g30 = arith.addf %c20, %c0_f64 : f64
    memref.store %g30, %buf[%c3_idx, %c0_idx] : memref<4x4xf64>
    %c21 = arith.constant 0.0 : f64
    %g31 = arith.addf %c21, %c0_f64 : f64
    memref.store %g31, %buf[%c3_idx, %c1_idx] : memref<4x4xf64>
    %c22 = arith.constant 0.0 : f64
    %g32 = arith.addf %c22, %c0_f64 : f64
    memref.store %g32, %buf[%c3_idx, %c2_idx] : memref<4x4xf64>
    %c23 = arith.constant 1.0 : f64
    %x25 = arith.mulf %r, %r : f64
    %x24 = arith.mulf %c23, %x25 : f64
    %c27 = arith.constant 1.0 : f64
    %x28 = arith.mulf %c27, %theta : f64
    %x29 = math.sin %x28 : f64
    %c31 = arith.constant 1.0 : f64
    %x32 = arith.mulf %c31, %theta : f64
    %x33 = math.sin %x32 : f64
    %x30 = arith.mulf %x29, %x33 : f64
    %x26 = arith.mulf %x24, %x30 : f64
    %g33 = arith.addf %x26, %c0_f64 : f64
    memref.store %g33, %buf[%c3_idx, %c3_idx] : memref<4x4xf64>
    return %buf : memref<4x4xf64>
  }
}