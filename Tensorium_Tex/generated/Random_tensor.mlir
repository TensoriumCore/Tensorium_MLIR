module {
  func.func @Random_tensor(%t: f64, %r: f64, %theta: f64, %phi: f64, %m: f64, %a: f64) -> memref<4x4xf64> {
    %buf = memref.alloc() : memref<4x4xf64>
    %c0_f64 = arith.constant 0.0 : f64
    %c1 = arith.constant -1.0 : f64
    %g00 = arith.addf %c1, %c0_f64 : f64
    %c0_idx = arith.constant 0 : index
    memref.store %g00, %buf[%c0_idx, %c0_idx] : memref<4x4xf64>
    %c2 = arith.constant 0.0 : f64
    %g01 = arith.addf %c2, %c0_f64 : f64
    %c1_idx = arith.constant 1 : index
    memref.store %g01, %buf[%c0_idx, %c1_idx] : memref<4x4xf64>
    %c3 = arith.constant 0.0 : f64
    %g02 = arith.addf %c3, %c0_f64 : f64
    %c2_idx = arith.constant 2 : index
    memref.store %g02, %buf[%c0_idx, %c2_idx] : memref<4x4xf64>
    %c4 = arith.constant 0.0 : f64
    %g03 = arith.addf %c4, %c0_f64 : f64
    %c3_idx = arith.constant 3 : index
    memref.store %g03, %buf[%c0_idx, %c3_idx] : memref<4x4xf64>
    %c5 = arith.constant 0.0 : f64
    %g10 = arith.addf %c5, %c0_f64 : f64
    memref.store %g10, %buf[%c1_idx, %c0_idx] : memref<4x4xf64>
    %c6 = arith.constant 1.0 : f64
    %g11 = arith.addf %c6, %c0_f64 : f64
    memref.store %g11, %buf[%c1_idx, %c1_idx] : memref<4x4xf64>
    %c7 = arith.constant 0.0 : f64
    %g12 = arith.addf %c7, %c0_f64 : f64
    memref.store %g12, %buf[%c1_idx, %c2_idx] : memref<4x4xf64>
    %c8 = arith.constant 0.0 : f64
    %g13 = arith.addf %c8, %c0_f64 : f64
    memref.store %g13, %buf[%c1_idx, %c3_idx] : memref<4x4xf64>
    %c9 = arith.constant 0.0 : f64
    %g20 = arith.addf %c9, %c0_f64 : f64
    memref.store %g20, %buf[%c2_idx, %c0_idx] : memref<4x4xf64>
    %c10 = arith.constant 0.0 : f64
    %g21 = arith.addf %c10, %c0_f64 : f64
    memref.store %g21, %buf[%c2_idx, %c1_idx] : memref<4x4xf64>
    %x11 = arith.mulf %r, %r : f64
    %g22 = arith.addf %x11, %c0_f64 : f64
    memref.store %g22, %buf[%c2_idx, %c2_idx] : memref<4x4xf64>
    %c12 = arith.constant 0.0 : f64
    %g23 = arith.addf %c12, %c0_f64 : f64
    memref.store %g23, %buf[%c2_idx, %c3_idx] : memref<4x4xf64>
    %c13 = arith.constant 0.0 : f64
    %g30 = arith.addf %c13, %c0_f64 : f64
    memref.store %g30, %buf[%c3_idx, %c0_idx] : memref<4x4xf64>
    %c14 = arith.constant 0.0 : f64
    %g31 = arith.addf %c14, %c0_f64 : f64
    memref.store %g31, %buf[%c3_idx, %c1_idx] : memref<4x4xf64>
    %c15 = arith.constant 0.0 : f64
    %g32 = arith.addf %c15, %c0_f64 : f64
    memref.store %g32, %buf[%c3_idx, %c2_idx] : memref<4x4xf64>
    %c16 = arith.constant 1.0 : f64
    %x17 = arith.mulf %r, %r : f64
    %c18 = arith.constant 1.0 : f64
    %x19 = arith.mulf %c18, %theta : f64
    %x20 = math.sin %x19 : f64
    %c22 = arith.constant 1.0 : f64
    %x23 = arith.mulf %c22, %theta : f64
    %x24 = math.sin %x23 : f64
    %x21 = arith.mulf %x20, %x24 : f64
    %x25 = arith.mulf %c16, %x17 : f64
    %x26 = arith.mulf %x25, %x21 : f64
    %g33 = arith.addf %x26, %c0_f64 : f64
    memref.store %g33, %buf[%c3_idx, %c3_idx] : memref<4x4xf64>
    return %buf : memref<4x4xf64>
  }
}