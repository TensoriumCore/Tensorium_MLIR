module {
  func.func @schwarzschild_christoffel(%t: f64, %r: f64, %theta: f64, %phi: f64, %m: f64, %a: f64) -> memref<4x4x4xf64> {
    %buf = memref.alloc() : memref<4x4x4xf64>
    %c0_f64 = arith.constant 0.0 : f64
    %c0 = arith.constant 0.0 : f64
    %g000 = arith.addf %c0, %c0_f64 : f64
    %c0_idx = arith.constant 0 : index
    memref.store %g000, %buf[%c0_idx, %c0_idx, %c0_idx] : memref<4x4x4xf64>
    %c1 = arith.constant 1.0 : f64
    %x2 = arith.divf %c1, %r : f64
    %c3 = arith.constant -2.0 : f64
    %x4 = arith.mulf %c3, %m : f64
    %x5 = arith.addf %r, %x4 : f64
    %c6 = arith.constant 1.0 : f64
    %x7 = arith.divf %c6, %x5 : f64
    %x8 = arith.mulf %m, %x2 : f64
    %x9 = arith.mulf %x8, %x7 : f64
    %g001 = arith.addf %x9, %c0_f64 : f64
    %c1_idx = arith.constant 1 : index
    memref.store %g001, %buf[%c0_idx, %c0_idx, %c1_idx] : memref<4x4x4xf64>
    %c10 = arith.constant 0.0 : f64
    %g002 = arith.addf %c10, %c0_f64 : f64
    %c2_idx = arith.constant 2 : index
    memref.store %g002, %buf[%c0_idx, %c0_idx, %c2_idx] : memref<4x4x4xf64>
    %c11 = arith.constant 0.0 : f64
    %g003 = arith.addf %c11, %c0_f64 : f64
    %c3_idx = arith.constant 3 : index
    memref.store %g003, %buf[%c0_idx, %c0_idx, %c3_idx] : memref<4x4x4xf64>
    %c12 = arith.constant 1.0 : f64
    %x13 = arith.divf %c12, %r : f64
    %c14 = arith.constant -2.0 : f64
    %x15 = arith.mulf %c14, %m : f64
    %x16 = arith.addf %r, %x15 : f64
    %c17 = arith.constant 1.0 : f64
    %x18 = arith.divf %c17, %x16 : f64
    %x19 = arith.mulf %m, %x13 : f64
    %x20 = arith.mulf %x19, %x18 : f64
    %g010 = arith.addf %x20, %c0_f64 : f64
    memref.store %g010, %buf[%c0_idx, %c1_idx, %c0_idx] : memref<4x4x4xf64>
    %c21 = arith.constant 0.0 : f64
    %g011 = arith.addf %c21, %c0_f64 : f64
    memref.store %g011, %buf[%c0_idx, %c1_idx, %c1_idx] : memref<4x4x4xf64>
    %c22 = arith.constant 0.0 : f64
    %g012 = arith.addf %c22, %c0_f64 : f64
    memref.store %g012, %buf[%c0_idx, %c1_idx, %c2_idx] : memref<4x4x4xf64>
    %c23 = arith.constant 0.0 : f64
    %g013 = arith.addf %c23, %c0_f64 : f64
    memref.store %g013, %buf[%c0_idx, %c1_idx, %c3_idx] : memref<4x4x4xf64>
    %c24 = arith.constant 0.0 : f64
    %g020 = arith.addf %c24, %c0_f64 : f64
    memref.store %g020, %buf[%c0_idx, %c2_idx, %c0_idx] : memref<4x4x4xf64>
    %c25 = arith.constant 0.0 : f64
    %g021 = arith.addf %c25, %c0_f64 : f64
    memref.store %g021, %buf[%c0_idx, %c2_idx, %c1_idx] : memref<4x4x4xf64>
    %c26 = arith.constant 0.0 : f64
    %g022 = arith.addf %c26, %c0_f64 : f64
    memref.store %g022, %buf[%c0_idx, %c2_idx, %c2_idx] : memref<4x4x4xf64>
    %c27 = arith.constant 0.0 : f64
    %g023 = arith.addf %c27, %c0_f64 : f64
    memref.store %g023, %buf[%c0_idx, %c2_idx, %c3_idx] : memref<4x4x4xf64>
    %c28 = arith.constant 0.0 : f64
    %g030 = arith.addf %c28, %c0_f64 : f64
    memref.store %g030, %buf[%c0_idx, %c3_idx, %c0_idx] : memref<4x4x4xf64>
    %c29 = arith.constant 0.0 : f64
    %g031 = arith.addf %c29, %c0_f64 : f64
    memref.store %g031, %buf[%c0_idx, %c3_idx, %c1_idx] : memref<4x4x4xf64>
    %c30 = arith.constant 0.0 : f64
    %g032 = arith.addf %c30, %c0_f64 : f64
    memref.store %g032, %buf[%c0_idx, %c3_idx, %c2_idx] : memref<4x4x4xf64>
    %c31 = arith.constant 0.0 : f64
    %g033 = arith.addf %c31, %c0_f64 : f64
    memref.store %g033, %buf[%c0_idx, %c3_idx, %c3_idx] : memref<4x4x4xf64>
    %x32 = arith.mulf %r, %r : f64
    %x33 = arith.mulf %x32, %r : f64
    %c34 = arith.constant 1.0 : f64
    %x35 = arith.divf %c34, %x33 : f64
    %c36 = arith.constant -2.0 : f64
    %x37 = arith.mulf %c36, %m : f64
    %x38 = arith.addf %r, %x37 : f64
    %x39 = arith.mulf %m, %x35 : f64
    %x40 = arith.mulf %x39, %x38 : f64
    %g100 = arith.addf %x40, %c0_f64 : f64
    memref.store %g100, %buf[%c1_idx, %c0_idx, %c0_idx] : memref<4x4x4xf64>
    %c41 = arith.constant 0.0 : f64
    %g101 = arith.addf %c41, %c0_f64 : f64
    memref.store %g101, %buf[%c1_idx, %c0_idx, %c1_idx] : memref<4x4x4xf64>
    %c42 = arith.constant 0.0 : f64
    %g102 = arith.addf %c42, %c0_f64 : f64
    memref.store %g102, %buf[%c1_idx, %c0_idx, %c2_idx] : memref<4x4x4xf64>
    %c43 = arith.constant 0.0 : f64
    %g103 = arith.addf %c43, %c0_f64 : f64
    memref.store %g103, %buf[%c1_idx, %c0_idx, %c3_idx] : memref<4x4x4xf64>
    %c44 = arith.constant 0.0 : f64
    %g110 = arith.addf %c44, %c0_f64 : f64
    memref.store %g110, %buf[%c1_idx, %c1_idx, %c0_idx] : memref<4x4x4xf64>
    %c45 = arith.constant 1.0 : f64
    %x46 = arith.divf %c45, %r : f64
    %c47 = arith.constant -1.0 : f64
    %x48 = arith.mulf %c47, %r : f64
    %c49 = arith.constant 2.0 : f64
    %x50 = arith.mulf %c49, %m : f64
    %x51 = arith.addf %x48, %x50 : f64
    %c52 = arith.constant 1.0 : f64
    %x53 = arith.divf %c52, %x51 : f64
    %x54 = arith.mulf %m, %x46 : f64
    %x55 = arith.mulf %x54, %x53 : f64
    %g111 = arith.addf %x55, %c0_f64 : f64
    memref.store %g111, %buf[%c1_idx, %c1_idx, %c1_idx] : memref<4x4x4xf64>
    %c56 = arith.constant 0.0 : f64
    %g112 = arith.addf %c56, %c0_f64 : f64
    memref.store %g112, %buf[%c1_idx, %c1_idx, %c2_idx] : memref<4x4x4xf64>
    %c57 = arith.constant 0.0 : f64
    %g113 = arith.addf %c57, %c0_f64 : f64
    memref.store %g113, %buf[%c1_idx, %c1_idx, %c3_idx] : memref<4x4x4xf64>
    %c58 = arith.constant 0.0 : f64
    %g120 = arith.addf %c58, %c0_f64 : f64
    memref.store %g120, %buf[%c1_idx, %c2_idx, %c0_idx] : memref<4x4x4xf64>
    %c59 = arith.constant 0.0 : f64
    %g121 = arith.addf %c59, %c0_f64 : f64
    memref.store %g121, %buf[%c1_idx, %c2_idx, %c1_idx] : memref<4x4x4xf64>
    %c60 = arith.constant -1.0 : f64
    %x61 = arith.mulf %c60, %r : f64
    %c62 = arith.constant 2.0 : f64
    %x63 = arith.mulf %c62, %m : f64
    %x64 = arith.addf %x61, %x63 : f64
    %g122 = arith.addf %x64, %c0_f64 : f64
    memref.store %g122, %buf[%c1_idx, %c2_idx, %c2_idx] : memref<4x4x4xf64>
    %c65 = arith.constant 0.0 : f64
    %g123 = arith.addf %c65, %c0_f64 : f64
    memref.store %g123, %buf[%c1_idx, %c2_idx, %c3_idx] : memref<4x4x4xf64>
    %c66 = arith.constant 0.0 : f64
    %g130 = arith.addf %c66, %c0_f64 : f64
    memref.store %g130, %buf[%c1_idx, %c3_idx, %c0_idx] : memref<4x4x4xf64>
    %c67 = arith.constant 0.0 : f64
    %g131 = arith.addf %c67, %c0_f64 : f64
    memref.store %g131, %buf[%c1_idx, %c3_idx, %c1_idx] : memref<4x4x4xf64>
    %c68 = arith.constant 0.0 : f64
    %g132 = arith.addf %c68, %c0_f64 : f64
    memref.store %g132, %buf[%c1_idx, %c3_idx, %c2_idx] : memref<4x4x4xf64>
    %c69 = arith.constant 1.0 : f64
    %x70 = arith.mulf %c69, %theta : f64
    %x71 = math.sin %x70 : f64
    %c73 = arith.constant 1.0 : f64
    %x74 = arith.mulf %c73, %theta : f64
    %x75 = math.sin %x74 : f64
    %x72 = arith.mulf %x71, %x75 : f64
    %c76 = arith.constant 2.0 : f64
    %x77 = arith.mulf %c76, %m : f64
    %c78 = arith.constant -1.0 : f64
    %x79 = arith.mulf %c78, %r : f64
    %x80 = arith.addf %x77, %x79 : f64
    %x81 = arith.mulf %x72, %x80 : f64
    %g133 = arith.addf %x81, %c0_f64 : f64
    memref.store %g133, %buf[%c1_idx, %c3_idx, %c3_idx] : memref<4x4x4xf64>
    %c82 = arith.constant 0.0 : f64
    %g200 = arith.addf %c82, %c0_f64 : f64
    memref.store %g200, %buf[%c2_idx, %c0_idx, %c0_idx] : memref<4x4x4xf64>
    %c83 = arith.constant 0.0 : f64
    %g201 = arith.addf %c83, %c0_f64 : f64
    memref.store %g201, %buf[%c2_idx, %c0_idx, %c1_idx] : memref<4x4x4xf64>
    %c84 = arith.constant 0.0 : f64
    %g202 = arith.addf %c84, %c0_f64 : f64
    memref.store %g202, %buf[%c2_idx, %c0_idx, %c2_idx] : memref<4x4x4xf64>
    %c85 = arith.constant 0.0 : f64
    %g203 = arith.addf %c85, %c0_f64 : f64
    memref.store %g203, %buf[%c2_idx, %c0_idx, %c3_idx] : memref<4x4x4xf64>
    %c86 = arith.constant 0.0 : f64
    %g210 = arith.addf %c86, %c0_f64 : f64
    memref.store %g210, %buf[%c2_idx, %c1_idx, %c0_idx] : memref<4x4x4xf64>
    %c87 = arith.constant 0.0 : f64
    %g211 = arith.addf %c87, %c0_f64 : f64
    memref.store %g211, %buf[%c2_idx, %c1_idx, %c1_idx] : memref<4x4x4xf64>
    %c88 = arith.constant 1.0 : f64
    %x89 = arith.divf %c88, %r : f64
    %g212 = arith.addf %x89, %c0_f64 : f64
    memref.store %g212, %buf[%c2_idx, %c1_idx, %c2_idx] : memref<4x4x4xf64>
    %c90 = arith.constant 0.0 : f64
    %g213 = arith.addf %c90, %c0_f64 : f64
    memref.store %g213, %buf[%c2_idx, %c1_idx, %c3_idx] : memref<4x4x4xf64>
    %c91 = arith.constant 0.0 : f64
    %g220 = arith.addf %c91, %c0_f64 : f64
    memref.store %g220, %buf[%c2_idx, %c2_idx, %c0_idx] : memref<4x4x4xf64>
    %c92 = arith.constant 1.0 : f64
    %x93 = arith.divf %c92, %r : f64
    %g221 = arith.addf %x93, %c0_f64 : f64
    memref.store %g221, %buf[%c2_idx, %c2_idx, %c1_idx] : memref<4x4x4xf64>
    %c94 = arith.constant 0.0 : f64
    %g222 = arith.addf %c94, %c0_f64 : f64
    memref.store %g222, %buf[%c2_idx, %c2_idx, %c2_idx] : memref<4x4x4xf64>
    %c95 = arith.constant 0.0 : f64
    %g223 = arith.addf %c95, %c0_f64 : f64
    memref.store %g223, %buf[%c2_idx, %c2_idx, %c3_idx] : memref<4x4x4xf64>
    %c96 = arith.constant 0.0 : f64
    %g230 = arith.addf %c96, %c0_f64 : f64
    memref.store %g230, %buf[%c2_idx, %c3_idx, %c0_idx] : memref<4x4x4xf64>
    %c97 = arith.constant 0.0 : f64
    %g231 = arith.addf %c97, %c0_f64 : f64
    memref.store %g231, %buf[%c2_idx, %c3_idx, %c1_idx] : memref<4x4x4xf64>
    %c98 = arith.constant 0.0 : f64
    %g232 = arith.addf %c98, %c0_f64 : f64
    memref.store %g232, %buf[%c2_idx, %c3_idx, %c2_idx] : memref<4x4x4xf64>
    %c99 = arith.constant -0.5 : f64
    %c100 = arith.constant 2.0 : f64
    %x101 = arith.mulf %c100, %theta : f64
    %x102 = math.sin %x101 : f64
    %x103 = arith.mulf %c99, %x102 : f64
    %g233 = arith.addf %x103, %c0_f64 : f64
    memref.store %g233, %buf[%c2_idx, %c3_idx, %c3_idx] : memref<4x4x4xf64>
    %c104 = arith.constant 0.0 : f64
    %g300 = arith.addf %c104, %c0_f64 : f64
    memref.store %g300, %buf[%c3_idx, %c0_idx, %c0_idx] : memref<4x4x4xf64>
    %c105 = arith.constant 0.0 : f64
    %g301 = arith.addf %c105, %c0_f64 : f64
    memref.store %g301, %buf[%c3_idx, %c0_idx, %c1_idx] : memref<4x4x4xf64>
    %c106 = arith.constant 0.0 : f64
    %g302 = arith.addf %c106, %c0_f64 : f64
    memref.store %g302, %buf[%c3_idx, %c0_idx, %c2_idx] : memref<4x4x4xf64>
    %c107 = arith.constant 0.0 : f64
    %g303 = arith.addf %c107, %c0_f64 : f64
    memref.store %g303, %buf[%c3_idx, %c0_idx, %c3_idx] : memref<4x4x4xf64>
    %c108 = arith.constant 0.0 : f64
    %g310 = arith.addf %c108, %c0_f64 : f64
    memref.store %g310, %buf[%c3_idx, %c1_idx, %c0_idx] : memref<4x4x4xf64>
    %c109 = arith.constant 0.0 : f64
    %g311 = arith.addf %c109, %c0_f64 : f64
    memref.store %g311, %buf[%c3_idx, %c1_idx, %c1_idx] : memref<4x4x4xf64>
    %c110 = arith.constant 0.0 : f64
    %g312 = arith.addf %c110, %c0_f64 : f64
    memref.store %g312, %buf[%c3_idx, %c1_idx, %c2_idx] : memref<4x4x4xf64>
    %c111 = arith.constant 1.0 : f64
    %c112 = arith.constant 1.0 : f64
    %x113 = arith.divf %c112, %r : f64
    %x114 = arith.mulf %c111, %x113 : f64
    %g313 = arith.addf %x114, %c0_f64 : f64
    memref.store %g313, %buf[%c3_idx, %c1_idx, %c3_idx] : memref<4x4x4xf64>
    %c115 = arith.constant 0.0 : f64
    %g320 = arith.addf %c115, %c0_f64 : f64
    memref.store %g320, %buf[%c3_idx, %c2_idx, %c0_idx] : memref<4x4x4xf64>
    %c116 = arith.constant 0.0 : f64
    %g321 = arith.addf %c116, %c0_f64 : f64
    memref.store %g321, %buf[%c3_idx, %c2_idx, %c1_idx] : memref<4x4x4xf64>
    %c117 = arith.constant 0.0 : f64
    %g322 = arith.addf %c117, %c0_f64 : f64
    memref.store %g322, %buf[%c3_idx, %c2_idx, %c2_idx] : memref<4x4x4xf64>
    %c118 = arith.constant 1.0 : f64
    %c119 = arith.constant 1.0 : f64
    %x120 = arith.mulf %c119, %theta : f64
    %x121 = math.tan %x120 : f64
    %c122 = arith.constant 1.0 : f64
    %x123 = arith.divf %c122, %x121 : f64
    %x124 = arith.mulf %c118, %x123 : f64
    %g323 = arith.addf %x124, %c0_f64 : f64
    memref.store %g323, %buf[%c3_idx, %c2_idx, %c3_idx] : memref<4x4x4xf64>
    %c125 = arith.constant 0.0 : f64
    %g330 = arith.addf %c125, %c0_f64 : f64
    memref.store %g330, %buf[%c3_idx, %c3_idx, %c0_idx] : memref<4x4x4xf64>
    %c126 = arith.constant 1.0 : f64
    %c127 = arith.constant 1.0 : f64
    %x128 = arith.divf %c127, %r : f64
    %x129 = arith.mulf %c126, %x128 : f64
    %g331 = arith.addf %x129, %c0_f64 : f64
    memref.store %g331, %buf[%c3_idx, %c3_idx, %c1_idx] : memref<4x4x4xf64>
    %c130 = arith.constant 1.0 : f64
    %c131 = arith.constant 1.0 : f64
    %x132 = arith.mulf %c131, %theta : f64
    %x133 = math.tan %x132 : f64
    %c134 = arith.constant 1.0 : f64
    %x135 = arith.divf %c134, %x133 : f64
    %x136 = arith.mulf %c130, %x135 : f64
    %g332 = arith.addf %x136, %c0_f64 : f64
    memref.store %g332, %buf[%c3_idx, %c3_idx, %c2_idx] : memref<4x4x4xf64>
    %c137 = arith.constant 0.0 : f64
    %g333 = arith.addf %c137, %c0_f64 : f64
    memref.store %g333, %buf[%c3_idx, %c3_idx, %c3_idx] : memref<4x4x4xf64>
    return %buf : memref<4x4x4xf64>
  }
}