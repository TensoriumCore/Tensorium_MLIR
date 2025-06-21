module {
  func.func @Random_tensor(%t: f64, %r: f64, %theta: f64, %phi: f64, %m: f64, %a: f64) -> memref<4x4xf64> {
    %buf = memref.alloc() : memref<4x4xf64>
    %c0_f64 = arith.constant 0.0 : f64
    %x1 = math.sin %t : f64
    %x2 = math.exp %x1 : f64
    %x3 = arith.negf %x2 : f64
    %g00 = arith.addf %x3, %c0_f64 : f64
    %c0_idx = arith.constant 0 : index
    memref.store %g00, %buf[%c0_idx, %c0_idx] : memref<4x4xf64>
    %c4 = arith.constant 0.0 : f64
    %g01 = arith.addf %c4, %c0_f64 : f64
    %c1_idx = arith.constant 1 : index
    memref.store %g01, %buf[%c0_idx, %c1_idx] : memref<4x4xf64>
    %c5 = arith.constant 0.0 : f64
    %g02 = arith.addf %c5, %c0_f64 : f64
    %c2_idx = arith.constant 2 : index
    memref.store %g02, %buf[%c0_idx, %c2_idx] : memref<4x4xf64>
    %c6 = arith.constant 0.0 : f64
    %g03 = arith.addf %c6, %c0_f64 : f64
    %c3_idx = arith.constant 3 : index
    memref.store %g03, %buf[%c0_idx, %c3_idx] : memref<4x4xf64>
    %c7 = arith.constant 0.0 : f64
    %g10 = arith.addf %c7, %c0_f64 : f64
    memref.store %g10, %buf[%c1_idx, %c0_idx] : memref<4x4xf64>
    %c8 = arith.constant 1.0 : f64
    %x9 = arith.mulf %r, %r : f64
    %x10 = arith.addf %c8, %x9 : f64
    %g11 = arith.addf %x10, %c0_f64 : f64
    memref.store %g11, %buf[%c1_idx, %c1_idx] : memref<4x4xf64>
    %c11 = arith.constant 0.0 : f64
    %g12 = arith.addf %c11, %c0_f64 : f64
    memref.store %g12, %buf[%c1_idx, %c2_idx] : memref<4x4xf64>
    %c12 = arith.constant 0.5 : f64
    %x13 = arith.mulf %c12, %r : f64
    %c15 = arith.constant 2.0 : f64
    %x16 = arith.mulf %c15, %theta : f64
    %x17 = math.sin %x16 : f64
    %x14 = arith.mulf %x13, %x17 : f64
    %g13 = arith.addf %x14, %c0_f64 : f64
    memref.store %g13, %buf[%c1_idx, %c3_idx] : memref<4x4xf64>
    %c18 = arith.constant 0.0 : f64
    %g20 = arith.addf %c18, %c0_f64 : f64
    memref.store %g20, %buf[%c2_idx, %c0_idx] : memref<4x4xf64>
    %c19 = arith.constant 0.0 : f64
    %g21 = arith.addf %c19, %c0_f64 : f64
    memref.store %g21, %buf[%c2_idx, %c1_idx] : memref<4x4xf64>
    %x20 = arith.mulf %r, %r : f64
    %g22 = arith.addf %x20, %c0_f64 : f64
    memref.store %g22, %buf[%c2_idx, %c2_idx] : memref<4x4xf64>
    %c21 = arith.constant 0.0 : f64
    %g23 = arith.addf %c21, %c0_f64 : f64
    memref.store %g23, %buf[%c2_idx, %c3_idx] : memref<4x4xf64>
    %c22 = arith.constant 0.0 : f64
    %g30 = arith.addf %c22, %c0_f64 : f64
    memref.store %g30, %buf[%c3_idx, %c0_idx] : memref<4x4xf64>
    %c23 = arith.constant 0.5 : f64
    %x24 = arith.mulf %c23, %r : f64
    %c26 = arith.constant 2.0 : f64
    %x27 = arith.mulf %c26, %theta : f64
    %x28 = math.sin %x27 : f64
    %x25 = arith.mulf %x24, %x28 : f64
    %g31 = arith.addf %x25, %c0_f64 : f64
    memref.store %g31, %buf[%c3_idx, %c1_idx] : memref<4x4xf64>
    %c29 = arith.constant 0.0 : f64
    %g32 = arith.addf %c29, %c0_f64 : f64
    memref.store %g32, %buf[%c3_idx, %c2_idx] : memref<4x4xf64>
    %c30 = arith.constant 1.0 : f64
    %c32 = arith.constant 1.0 : f64
    %x33 = arith.mulf %c32, %theta : f64
    %x34 = math.cos %x33 : f64
    %x31 = arith.mulf %c30, %x34 : f64
    %g33 = arith.addf %x31, %c0_f64 : f64
    memref.store %g33, %buf[%c3_idx, %c3_idx] : memref<4x4xf64>
    return %buf : memref<4x4xf64>
  }
}