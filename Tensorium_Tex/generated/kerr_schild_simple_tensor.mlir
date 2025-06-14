module {
  func.func @kerr_schild_simple_tensor(%t: f64, %r: f64, %theta: f64, %phi: f64) -> memref<4x4xf64> {
    %buf = memref.alloc() : memref<4x4xf64>
    %c0_f64 = arith.constant 0.0 : f64
    %x1 = arith.mulf %r, %r : f64
    %x2 = arith.mulf %x1, %r : f64
    %x3 = arith.mulf %x2, %r : f64
    %cU4 = arith.constant 0.0 : f64  // undef a
    %x5 = arith.mulf %cU4, %cU4 : f64
    %cU6 = arith.constant 0.0 : f64  // undef z
    %x7 = arith.mulf %cU6, %cU6 : f64
    %x8 = arith.mulf %x5, %x7 : f64
    %x9 = arith.addf %x3, %x8 : f64
    %x0 = arith.addf %x9, %c0_f64 : f64
    %cU10 = arith.constant 0.0 : f64  // undef x0
    %c11 = arith.constant 1.0 : f64
    %x12 = arith.divf %c11, %cU10 : f64
    %c13 = arith.constant -1.0 : f64
    %x14 = arith.mulf %c13, %cU10 : f64
    %c15 = arith.constant 2.0 : f64
    %cU16 = arith.constant 0.0 : f64  // undef m
    %x17 = arith.mulf %r, %r : f64
    %x18 = arith.mulf %x17, %r : f64
    %x19 = arith.mulf %c15, %cU16 : f64
    %x20 = arith.mulf %x19, %x18 : f64
    %x21 = arith.addf %x14, %x20 : f64
    %x22 = arith.mulf %x12, %x21 : f64
    %g00 = arith.addf %x22, %c0_f64 : f64
    %c0_idx = arith.constant 0 : index
    memref.store %g00, %buf[%c0_idx, %c0_idx] : memref<4x4xf64>
    %c23 = arith.constant 0.0 : f64
    %g01 = arith.addf %c23, %c0_f64 : f64
    %c1_idx = arith.constant 1 : index
    memref.store %g01, %buf[%c0_idx, %c1_idx] : memref<4x4xf64>
    %c24 = arith.constant 0.0 : f64
    %g02 = arith.addf %c24, %c0_f64 : f64
    %c2_idx = arith.constant 2 : index
    memref.store %g02, %buf[%c0_idx, %c2_idx] : memref<4x4xf64>
    %c25 = arith.constant 0.0 : f64
    %g03 = arith.addf %c25, %c0_f64 : f64
    %c3_idx = arith.constant 3 : index
    memref.store %g03, %buf[%c0_idx, %c3_idx] : memref<4x4xf64>
    %c26 = arith.constant 0.0 : f64
    %g10 = arith.addf %c26, %c0_f64 : f64
    memref.store %g10, %buf[%c1_idx, %c0_idx] : memref<4x4xf64>
    %c27 = arith.constant 0.0 : f64
    %g11 = arith.addf %c27, %c0_f64 : f64
    memref.store %g11, %buf[%c1_idx, %c1_idx] : memref<4x4xf64>
    %c28 = arith.constant 0.0 : f64
    %g12 = arith.addf %c28, %c0_f64 : f64
    memref.store %g12, %buf[%c1_idx, %c2_idx] : memref<4x4xf64>
    %c29 = arith.constant 0.0 : f64
    %g13 = arith.addf %c29, %c0_f64 : f64
    memref.store %g13, %buf[%c1_idx, %c3_idx] : memref<4x4xf64>
    %c30 = arith.constant 0.0 : f64
    %g20 = arith.addf %c30, %c0_f64 : f64
    memref.store %g20, %buf[%c2_idx, %c0_idx] : memref<4x4xf64>
    %c31 = arith.constant 0.0 : f64
    %g21 = arith.addf %c31, %c0_f64 : f64
    memref.store %g21, %buf[%c2_idx, %c1_idx] : memref<4x4xf64>
    %c32 = arith.constant 0.0 : f64
    %g22 = arith.addf %c32, %c0_f64 : f64
    memref.store %g22, %buf[%c2_idx, %c2_idx] : memref<4x4xf64>
    %c33 = arith.constant 0.0 : f64
    %g23 = arith.addf %c33, %c0_f64 : f64
    memref.store %g23, %buf[%c2_idx, %c3_idx] : memref<4x4xf64>
    %c34 = arith.constant 0.0 : f64
    %g30 = arith.addf %c34, %c0_f64 : f64
    memref.store %g30, %buf[%c3_idx, %c0_idx] : memref<4x4xf64>
    %c35 = arith.constant 0.0 : f64
    %g31 = arith.addf %c35, %c0_f64 : f64
    memref.store %g31, %buf[%c3_idx, %c1_idx] : memref<4x4xf64>
    %c36 = arith.constant 0.0 : f64
    %g32 = arith.addf %c36, %c0_f64 : f64
    memref.store %g32, %buf[%c3_idx, %c2_idx] : memref<4x4xf64>
    %c37 = arith.constant 0.0 : f64
    %g33 = arith.addf %c37, %c0_f64 : f64
    memref.store %g33, %buf[%c3_idx, %c3_idx] : memref<4x4xf64>
    return %buf : memref<4x4xf64>
  }
}