module {
  func.func @schwarzschild_tensor(%t: f64, %r: f64, %theta: f64, %phi: f64) -> memref<4x4xf64> {
    %buf = memref.alloc() : memref<4x4xf64>
    %c0_f64 = arith.constant 0.0 : f64
    %c1 = arith.constant 1.0 : f64
    %x2 = arith.divf %c1, %r : f64
    %c3 = arith.constant -1.0 : f64
    %x4 = arith.mulf %c3, %r : f64
    %c5 = arith.constant 2.0 : f64
    %cU6 = arith.constant 0.0 : f64  // undef m
    %x7 = arith.mulf %c5, %cU6 : f64
    %x8 = arith.addf %x4, %x7 : f64
    %x9 = arith.mulf %x2, %x8 : f64
    %g00 = arith.addf %x9, %c0_f64 : f64
    %c0_idx = arith.constant 0 : index
    memref.store %g00, %buf[%c0_idx, %c0_idx] : memref<4x4xf64>
    %c10 = arith.constant 0.0 : f64
    %g01 = arith.addf %c10, %c0_f64 : f64
    %c1_idx = arith.constant 1 : index
    memref.store %g01, %buf[%c0_idx, %c1_idx] : memref<4x4xf64>
    %c11 = arith.constant 0.0 : f64
    %g02 = arith.addf %c11, %c0_f64 : f64
    %c2_idx = arith.constant 2 : index
    memref.store %g02, %buf[%c0_idx, %c2_idx] : memref<4x4xf64>
    %c12 = arith.constant 0.0 : f64
    %g03 = arith.addf %c12, %c0_f64 : f64
    %c3_idx = arith.constant 3 : index
    memref.store %g03, %buf[%c0_idx, %c3_idx] : memref<4x4xf64>
    %c13 = arith.constant 0.0 : f64
    %g10 = arith.addf %c13, %c0_f64 : f64
    memref.store %g10, %buf[%c1_idx, %c0_idx] : memref<4x4xf64>
    %c14 = arith.constant -2.0 : f64
    %cU15 = arith.constant 0.0 : f64  // undef m
    %x16 = arith.mulf %c14, %cU15 : f64
    %x17 = arith.addf %r, %x16 : f64
    %c18 = arith.constant 1.0 : f64
    %x19 = arith.divf %c18, %x17 : f64
    %x20 = arith.mulf %r, %x19 : f64
    %g11 = arith.addf %x20, %c0_f64 : f64
    memref.store %g11, %buf[%c1_idx, %c1_idx] : memref<4x4xf64>
    %c21 = arith.constant 0.0 : f64
    %g12 = arith.addf %c21, %c0_f64 : f64
    memref.store %g12, %buf[%c1_idx, %c2_idx] : memref<4x4xf64>
    %c22 = arith.constant 0.0 : f64
    %g13 = arith.addf %c22, %c0_f64 : f64
    memref.store %g13, %buf[%c1_idx, %c3_idx] : memref<4x4xf64>
    %c23 = arith.constant 0.0 : f64
    %g20 = arith.addf %c23, %c0_f64 : f64
    memref.store %g20, %buf[%c2_idx, %c0_idx] : memref<4x4xf64>
    %c24 = arith.constant 0.0 : f64
    %g21 = arith.addf %c24, %c0_f64 : f64
    memref.store %g21, %buf[%c2_idx, %c1_idx] : memref<4x4xf64>
    %x25 = arith.mulf %r, %r : f64
    %g22 = arith.addf %x25, %c0_f64 : f64
    memref.store %g22, %buf[%c2_idx, %c2_idx] : memref<4x4xf64>
    %c26 = arith.constant 0.0 : f64
    %g23 = arith.addf %c26, %c0_f64 : f64
    memref.store %g23, %buf[%c2_idx, %c3_idx] : memref<4x4xf64>
    %c27 = arith.constant 0.0 : f64
    %g30 = arith.addf %c27, %c0_f64 : f64
    memref.store %g30, %buf[%c3_idx, %c0_idx] : memref<4x4xf64>
    %c28 = arith.constant 0.0 : f64
    %g31 = arith.addf %c28, %c0_f64 : f64
    memref.store %g31, %buf[%c3_idx, %c1_idx] : memref<4x4xf64>
    %c29 = arith.constant 0.0 : f64
    %g32 = arith.addf %c29, %c0_f64 : f64
    memref.store %g32, %buf[%c3_idx, %c2_idx] : memref<4x4xf64>
    %c30 = arith.constant 1.0 : f64
    %x31 = arith.mulf %r, %r : f64
    %c32 = arith.constant 1.0 : f64
    %x33 = arith.mulf %c32, %theta : f64
    %x34 = math.sin %x33 : f64
    %c36 = arith.constant 1.0 : f64
    %x37 = arith.mulf %c36, %theta : f64
    %x38 = math.sin %x37 : f64
    %x35 = arith.mulf %x34, %x38 : f64
    %x39 = arith.mulf %c30, %x31 : f64
    %x40 = arith.mulf %x39, %x35 : f64
    %g33 = arith.addf %x40, %c0_f64 : f64
    memref.store %g33, %buf[%c3_idx, %c3_idx] : memref<4x4xf64>
    return %buf : memref<4x4xf64>
  }
}