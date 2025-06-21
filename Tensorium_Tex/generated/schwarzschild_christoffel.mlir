module {
  func.func @schwarzschild_christoffel(%t: f64, %r: f64, %theta: f64, %phi: f64, %m: f64, %a: f64) -> memref<4x4x4xf64> {
    %buf = memref.alloc() : memref<4x4x4xf64>
    %c0_f64 = arith.constant 0.0 : f64
    %c0 = arith.constant 0.0 : f64
    %g000 = arith.addf %c0, %c0_f64 : f64
    %c0_idx = arith.constant 0 : index
    memref.store %g000, %buf[%c0_idx, %c0_idx, %c0_idx] : memref<4x4x4xf64>
    %c1 = arith.constant 1.0 : f64
    %c2 = arith.constant 1.0 : f64
    %x3 = arith.divf %c2, %r : f64
    %c4 = arith.constant 1.0 : f64
    %x5 = arith.mulf %c4, %r : f64
    %c6 = arith.constant -2.0 : f64
    %x7 = arith.mulf %c6, %m : f64
    %x8 = arith.addf %x5, %x7 : f64
    %c9 = arith.constant 1.0 : f64
    %x10 = arith.divf %c9, %x8 : f64
    %x11 = arith.mulf %c1, %m : f64
    %x12 = arith.mulf %x11, %x3 : f64
    %x13 = arith.mulf %x12, %x10 : f64
    %g001 = arith.addf %x13, %c0_f64 : f64
    %c1_idx = arith.constant 1 : index
    memref.store %g001, %buf[%c0_idx, %c0_idx, %c1_idx] : memref<4x4x4xf64>
    %c14 = arith.constant 0.0 : f64
    %g002 = arith.addf %c14, %c0_f64 : f64
    %c2_idx = arith.constant 2 : index
    memref.store %g002, %buf[%c0_idx, %c0_idx, %c2_idx] : memref<4x4x4xf64>
    %c15 = arith.constant 0.0 : f64
    %g003 = arith.addf %c15, %c0_f64 : f64
    %c3_idx = arith.constant 3 : index
    memref.store %g003, %buf[%c0_idx, %c0_idx, %c3_idx] : memref<4x4x4xf64>
    %c16 = arith.constant 1.0 : f64
    %c17 = arith.constant 1.0 : f64
    %x18 = arith.divf %c17, %r : f64
    %c19 = arith.constant 1.0 : f64
    %x20 = arith.mulf %c19, %r : f64
    %c21 = arith.constant -2.0 : f64
    %x22 = arith.mulf %c21, %m : f64
    %x23 = arith.addf %x20, %x22 : f64
    %c24 = arith.constant 1.0 : f64
    %x25 = arith.divf %c24, %x23 : f64
    %x26 = arith.mulf %c16, %m : f64
    %x27 = arith.mulf %x26, %x18 : f64
    %x28 = arith.mulf %x27, %x25 : f64
    %g010 = arith.addf %x28, %c0_f64 : f64
    memref.store %g010, %buf[%c0_idx, %c1_idx, %c0_idx] : memref<4x4x4xf64>
    %c29 = arith.constant 0.0 : f64
    %g011 = arith.addf %c29, %c0_f64 : f64
    memref.store %g011, %buf[%c0_idx, %c1_idx, %c1_idx] : memref<4x4x4xf64>
    %c30 = arith.constant 0.0 : f64
    %g012 = arith.addf %c30, %c0_f64 : f64
    memref.store %g012, %buf[%c0_idx, %c1_idx, %c2_idx] : memref<4x4x4xf64>
    %c31 = arith.constant 0.0 : f64
    %g013 = arith.addf %c31, %c0_f64 : f64
    memref.store %g013, %buf[%c0_idx, %c1_idx, %c3_idx] : memref<4x4x4xf64>
    %c32 = arith.constant 0.0 : f64
    %g020 = arith.addf %c32, %c0_f64 : f64
    memref.store %g020, %buf[%c0_idx, %c2_idx, %c0_idx] : memref<4x4x4xf64>
    %c33 = arith.constant 0.0 : f64
    %g021 = arith.addf %c33, %c0_f64 : f64
    memref.store %g021, %buf[%c0_idx, %c2_idx, %c1_idx] : memref<4x4x4xf64>
    %c34 = arith.constant 0.0 : f64
    %g022 = arith.addf %c34, %c0_f64 : f64
    memref.store %g022, %buf[%c0_idx, %c2_idx, %c2_idx] : memref<4x4x4xf64>
    %c35 = arith.constant 0.0 : f64
    %g023 = arith.addf %c35, %c0_f64 : f64
    memref.store %g023, %buf[%c0_idx, %c2_idx, %c3_idx] : memref<4x4x4xf64>
    %c36 = arith.constant 0.0 : f64
    %g030 = arith.addf %c36, %c0_f64 : f64
    memref.store %g030, %buf[%c0_idx, %c3_idx, %c0_idx] : memref<4x4x4xf64>
    %c37 = arith.constant 0.0 : f64
    %g031 = arith.addf %c37, %c0_f64 : f64
    memref.store %g031, %buf[%c0_idx, %c3_idx, %c1_idx] : memref<4x4x4xf64>
    %c38 = arith.constant 0.0 : f64
    %g032 = arith.addf %c38, %c0_f64 : f64
    memref.store %g032, %buf[%c0_idx, %c3_idx, %c2_idx] : memref<4x4x4xf64>
    %c39 = arith.constant 0.0 : f64
    %g033 = arith.addf %c39, %c0_f64 : f64
    memref.store %g033, %buf[%c0_idx, %c3_idx, %c3_idx] : memref<4x4x4xf64>
    %c40 = arith.constant 1.0 : f64
    %x41 = arith.mulf %r, %r : f64
    %x42 = arith.mulf %x41, %r : f64
    %c43 = arith.constant 1.0 : f64
    %x44 = arith.divf %c43, %x42 : f64
    %c45 = arith.constant 1.0 : f64
    %x46 = arith.mulf %c45, %r : f64
    %c47 = arith.constant -2.0 : f64
    %x48 = arith.mulf %c47, %m : f64
    %x49 = arith.addf %x46, %x48 : f64
    %x50 = arith.mulf %c40, %m : f64
    %x51 = arith.mulf %x50, %x44 : f64
    %x52 = arith.mulf %x51, %x49 : f64
    %g100 = arith.addf %x52, %c0_f64 : f64
    memref.store %g100, %buf[%c1_idx, %c0_idx, %c0_idx] : memref<4x4x4xf64>
    %c53 = arith.constant 0.0 : f64
    %g101 = arith.addf %c53, %c0_f64 : f64
    memref.store %g101, %buf[%c1_idx, %c0_idx, %c1_idx] : memref<4x4x4xf64>
    %c54 = arith.constant 0.0 : f64
    %g102 = arith.addf %c54, %c0_f64 : f64
    memref.store %g102, %buf[%c1_idx, %c0_idx, %c2_idx] : memref<4x4x4xf64>
    %c55 = arith.constant 0.0 : f64
    %g103 = arith.addf %c55, %c0_f64 : f64
    memref.store %g103, %buf[%c1_idx, %c0_idx, %c3_idx] : memref<4x4x4xf64>
    %c56 = arith.constant 0.0 : f64
    %g110 = arith.addf %c56, %c0_f64 : f64
    memref.store %g110, %buf[%c1_idx, %c1_idx, %c0_idx] : memref<4x4x4xf64>
    %c57 = arith.constant 1.0 : f64
    %c58 = arith.constant 1.0 : f64
    %x59 = arith.divf %c58, %r : f64
    %c60 = arith.constant 2.0 : f64
    %x61 = arith.mulf %c60, %m : f64
    %c62 = arith.constant -1.0 : f64
    %x63 = arith.mulf %c62, %r : f64
    %x64 = arith.addf %x61, %x63 : f64
    %c65 = arith.constant 1.0 : f64
    %x66 = arith.divf %c65, %x64 : f64
    %x67 = arith.mulf %c57, %m : f64
    %x68 = arith.mulf %x67, %x59 : f64
    %x69 = arith.mulf %x68, %x66 : f64
    %g111 = arith.addf %x69, %c0_f64 : f64
    memref.store %g111, %buf[%c1_idx, %c1_idx, %c1_idx] : memref<4x4x4xf64>
    %c70 = arith.constant 0.0 : f64
    %g112 = arith.addf %c70, %c0_f64 : f64
    memref.store %g112, %buf[%c1_idx, %c1_idx, %c2_idx] : memref<4x4x4xf64>
    %c71 = arith.constant 0.0 : f64
    %g113 = arith.addf %c71, %c0_f64 : f64
    memref.store %g113, %buf[%c1_idx, %c1_idx, %c3_idx] : memref<4x4x4xf64>
    %c72 = arith.constant 0.0 : f64
    %g120 = arith.addf %c72, %c0_f64 : f64
    memref.store %g120, %buf[%c1_idx, %c2_idx, %c0_idx] : memref<4x4x4xf64>
    %c73 = arith.constant 0.0 : f64
    %g121 = arith.addf %c73, %c0_f64 : f64
    memref.store %g121, %buf[%c1_idx, %c2_idx, %c1_idx] : memref<4x4x4xf64>
    %c74 = arith.constant 2.0 : f64
    %x75 = arith.mulf %c74, %m : f64
    %c76 = arith.constant -1.0 : f64
    %x77 = arith.mulf %c76, %r : f64
    %x78 = arith.addf %x75, %x77 : f64
    %g122 = arith.addf %x78, %c0_f64 : f64
    memref.store %g122, %buf[%c1_idx, %c2_idx, %c2_idx] : memref<4x4x4xf64>
    %c79 = arith.constant 0.0 : f64
    %g123 = arith.addf %c79, %c0_f64 : f64
    memref.store %g123, %buf[%c1_idx, %c2_idx, %c3_idx] : memref<4x4x4xf64>
    %c80 = arith.constant 0.0 : f64
    %g130 = arith.addf %c80, %c0_f64 : f64
    memref.store %g130, %buf[%c1_idx, %c3_idx, %c0_idx] : memref<4x4x4xf64>
    %c81 = arith.constant 0.0 : f64
    %g131 = arith.addf %c81, %c0_f64 : f64
    memref.store %g131, %buf[%c1_idx, %c3_idx, %c1_idx] : memref<4x4x4xf64>
    %c82 = arith.constant 0.0 : f64
    %g132 = arith.addf %c82, %c0_f64 : f64
    memref.store %g132, %buf[%c1_idx, %c3_idx, %c2_idx] : memref<4x4x4xf64>
    %c83 = arith.constant 1.0 : f64
    %x84 = arith.mulf %c83, %theta : f64
    %x85 = math.sin %x84 : f64
    %c87 = arith.constant 1.0 : f64
    %x88 = arith.mulf %c87, %theta : f64
    %x89 = math.sin %x88 : f64
    %x86 = arith.mulf %x85, %x89 : f64
    %c90 = arith.constant 2.0 : f64
    %x91 = arith.mulf %c90, %m : f64
    %c92 = arith.constant -1.0 : f64
    %x93 = arith.mulf %c92, %r : f64
    %x94 = arith.addf %x91, %x93 : f64
    %x95 = arith.mulf %x86, %x94 : f64
    %g133 = arith.addf %x95, %c0_f64 : f64
    memref.store %g133, %buf[%c1_idx, %c3_idx, %c3_idx] : memref<4x4x4xf64>
    %c96 = arith.constant 0.0 : f64
    %g200 = arith.addf %c96, %c0_f64 : f64
    memref.store %g200, %buf[%c2_idx, %c0_idx, %c0_idx] : memref<4x4x4xf64>
    %c97 = arith.constant 0.0 : f64
    %g201 = arith.addf %c97, %c0_f64 : f64
    memref.store %g201, %buf[%c2_idx, %c0_idx, %c1_idx] : memref<4x4x4xf64>
    %c98 = arith.constant 0.0 : f64
    %g202 = arith.addf %c98, %c0_f64 : f64
    memref.store %g202, %buf[%c2_idx, %c0_idx, %c2_idx] : memref<4x4x4xf64>
    %c99 = arith.constant 0.0 : f64
    %g203 = arith.addf %c99, %c0_f64 : f64
    memref.store %g203, %buf[%c2_idx, %c0_idx, %c3_idx] : memref<4x4x4xf64>
    %c100 = arith.constant 0.0 : f64
    %g210 = arith.addf %c100, %c0_f64 : f64
    memref.store %g210, %buf[%c2_idx, %c1_idx, %c0_idx] : memref<4x4x4xf64>
    %c101 = arith.constant 0.0 : f64
    %g211 = arith.addf %c101, %c0_f64 : f64
    memref.store %g211, %buf[%c2_idx, %c1_idx, %c1_idx] : memref<4x4x4xf64>
    %c102 = arith.constant 1.0 : f64
    %c103 = arith.constant 1.0 : f64
    %x104 = arith.divf %c103, %r : f64
    %x105 = arith.mulf %c102, %x104 : f64
    %g212 = arith.addf %x105, %c0_f64 : f64
    memref.store %g212, %buf[%c2_idx, %c1_idx, %c2_idx] : memref<4x4x4xf64>
    %c106 = arith.constant 0.0 : f64
    %g213 = arith.addf %c106, %c0_f64 : f64
    memref.store %g213, %buf[%c2_idx, %c1_idx, %c3_idx] : memref<4x4x4xf64>
    %c107 = arith.constant 0.0 : f64
    %g220 = arith.addf %c107, %c0_f64 : f64
    memref.store %g220, %buf[%c2_idx, %c2_idx, %c0_idx] : memref<4x4x4xf64>
    %c108 = arith.constant 1.0 : f64
    %c109 = arith.constant 1.0 : f64
    %x110 = arith.divf %c109, %r : f64
    %x111 = arith.mulf %c108, %x110 : f64
    %g221 = arith.addf %x111, %c0_f64 : f64
    memref.store %g221, %buf[%c2_idx, %c2_idx, %c1_idx] : memref<4x4x4xf64>
    %c112 = arith.constant 0.0 : f64
    %g222 = arith.addf %c112, %c0_f64 : f64
    memref.store %g222, %buf[%c2_idx, %c2_idx, %c2_idx] : memref<4x4x4xf64>
    %c113 = arith.constant 0.0 : f64
    %g223 = arith.addf %c113, %c0_f64 : f64
    memref.store %g223, %buf[%c2_idx, %c2_idx, %c3_idx] : memref<4x4x4xf64>
    %c114 = arith.constant 0.0 : f64
    %g230 = arith.addf %c114, %c0_f64 : f64
    memref.store %g230, %buf[%c2_idx, %c3_idx, %c0_idx] : memref<4x4x4xf64>
    %c115 = arith.constant 0.0 : f64
    %g231 = arith.addf %c115, %c0_f64 : f64
    memref.store %g231, %buf[%c2_idx, %c3_idx, %c1_idx] : memref<4x4x4xf64>
    %c116 = arith.constant 0.0 : f64
    %g232 = arith.addf %c116, %c0_f64 : f64
    memref.store %g232, %buf[%c2_idx, %c3_idx, %c2_idx] : memref<4x4x4xf64>
    %c117 = arith.constant -0.5 : f64
    %c118 = arith.constant 2.0 : f64
    %x119 = arith.mulf %c118, %theta : f64
    %x120 = math.sin %x119 : f64
    %x121 = arith.mulf %c117, %x120 : f64
    %g233 = arith.addf %x121, %c0_f64 : f64
    memref.store %g233, %buf[%c2_idx, %c3_idx, %c3_idx] : memref<4x4x4xf64>
    %c122 = arith.constant 0.0 : f64
    %g300 = arith.addf %c122, %c0_f64 : f64
    memref.store %g300, %buf[%c3_idx, %c0_idx, %c0_idx] : memref<4x4x4xf64>
    %c123 = arith.constant 0.0 : f64
    %g301 = arith.addf %c123, %c0_f64 : f64
    memref.store %g301, %buf[%c3_idx, %c0_idx, %c1_idx] : memref<4x4x4xf64>
    %c124 = arith.constant 0.0 : f64
    %g302 = arith.addf %c124, %c0_f64 : f64
    memref.store %g302, %buf[%c3_idx, %c0_idx, %c2_idx] : memref<4x4x4xf64>
    %c125 = arith.constant 0.0 : f64
    %g303 = arith.addf %c125, %c0_f64 : f64
    memref.store %g303, %buf[%c3_idx, %c0_idx, %c3_idx] : memref<4x4x4xf64>
    %c126 = arith.constant 0.0 : f64
    %g310 = arith.addf %c126, %c0_f64 : f64
    memref.store %g310, %buf[%c3_idx, %c1_idx, %c0_idx] : memref<4x4x4xf64>
    %c127 = arith.constant 0.0 : f64
    %g311 = arith.addf %c127, %c0_f64 : f64
    memref.store %g311, %buf[%c3_idx, %c1_idx, %c1_idx] : memref<4x4x4xf64>
    %c128 = arith.constant 0.0 : f64
    %g312 = arith.addf %c128, %c0_f64 : f64
    memref.store %g312, %buf[%c3_idx, %c1_idx, %c2_idx] : memref<4x4x4xf64>
    %c129 = arith.constant 1.0 : f64
    %c130 = arith.constant 1.0 : f64
    %x131 = arith.divf %c130, %r : f64
    %x132 = arith.mulf %c129, %x131 : f64
    %g313 = arith.addf %x132, %c0_f64 : f64
    memref.store %g313, %buf[%c3_idx, %c1_idx, %c3_idx] : memref<4x4x4xf64>
    %c133 = arith.constant 0.0 : f64
    %g320 = arith.addf %c133, %c0_f64 : f64
    memref.store %g320, %buf[%c3_idx, %c2_idx, %c0_idx] : memref<4x4x4xf64>
    %c134 = arith.constant 0.0 : f64
    %g321 = arith.addf %c134, %c0_f64 : f64
    memref.store %g321, %buf[%c3_idx, %c2_idx, %c1_idx] : memref<4x4x4xf64>
    %c135 = arith.constant 0.0 : f64
    %g322 = arith.addf %c135, %c0_f64 : f64
    memref.store %g322, %buf[%c3_idx, %c2_idx, %c2_idx] : memref<4x4x4xf64>
    %c136 = arith.constant 1.0 : f64
    %c137 = arith.constant 1.0 : f64
    %x138 = arith.mulf %c137, %theta : f64
    %x139 = math.tan %x138 : f64
    %c140 = arith.constant 1.0 : f64
    %x141 = arith.divf %c140, %x139 : f64
    %x142 = arith.mulf %c136, %x141 : f64
    %g323 = arith.addf %x142, %c0_f64 : f64
    memref.store %g323, %buf[%c3_idx, %c2_idx, %c3_idx] : memref<4x4x4xf64>
    %c143 = arith.constant 0.0 : f64
    %g330 = arith.addf %c143, %c0_f64 : f64
    memref.store %g330, %buf[%c3_idx, %c3_idx, %c0_idx] : memref<4x4x4xf64>
    %c144 = arith.constant 1.0 : f64
    %c145 = arith.constant 1.0 : f64
    %x146 = arith.divf %c145, %r : f64
    %x147 = arith.mulf %c144, %x146 : f64
    %g331 = arith.addf %x147, %c0_f64 : f64
    memref.store %g331, %buf[%c3_idx, %c3_idx, %c1_idx] : memref<4x4x4xf64>
    %c148 = arith.constant 1.0 : f64
    %c149 = arith.constant 1.0 : f64
    %x150 = arith.mulf %c149, %theta : f64
    %x151 = math.tan %x150 : f64
    %c152 = arith.constant 1.0 : f64
    %x153 = arith.divf %c152, %x151 : f64
    %x154 = arith.mulf %c148, %x153 : f64
    %g332 = arith.addf %x154, %c0_f64 : f64
    memref.store %g332, %buf[%c3_idx, %c3_idx, %c2_idx] : memref<4x4x4xf64>
    %c155 = arith.constant 0.0 : f64
    %g333 = arith.addf %c155, %c0_f64 : f64
    memref.store %g333, %buf[%c3_idx, %c3_idx, %c3_idx] : memref<4x4x4xf64>
    return %buf : memref<4x4x4xf64>
  }
}