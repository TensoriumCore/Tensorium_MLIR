module {
  llvm.func @malloc(i64) -> !llvm.ptr
  llvm.func @SchwarzschildSpatial(%arg0: f64, %arg1: f64, %arg2: f64, %arg3: f64) -> !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> attributes {llvm.emit_c_interface} {
    %0 = llvm.mlir.constant(3 : index) : i64
    %1 = llvm.mlir.constant(0 : index) : i64
    %2 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %3 = llvm.mlir.constant(64 : index) : i64
    %4 = llvm.mlir.zero : !llvm.ptr
    %5 = llvm.mlir.constant(1 : index) : i64
    %6 = llvm.mlir.constant(4 : index) : i64
    %7 = llvm.mlir.constant(1.000000e+00 : f64) : f64
    %8 = llvm.mlir.constant(1 : index) : i64
    %9 = llvm.mlir.constant(2 : index) : i64
    %10 = llvm.mlir.constant(3 : index) : i64
    %11 = llvm.mlir.constant(1.000000e-30 : f64) : f64
    %12 = llvm.mlir.constant(2.000000e+00 : f64) : f64
    %13 = llvm.mlir.constant(-1.000000e+00 : f64) : f64
    %14 = llvm.mlir.constant(0 : index) : i64
    %15 = llvm.mlir.undef : vector<4xf64>
    %16 = llvm.mlir.constant(0 : i64) : i64
    %17 = llvm.insertelement %arg0, %15[%16 : i64] : vector<4xf64>
    %18 = llvm.mlir.constant(1 : i64) : i64
    %19 = llvm.insertelement %arg1, %17[%18 : i64] : vector<4xf64>
    %20 = llvm.mlir.constant(2 : i64) : i64
    %21 = llvm.insertelement %arg2, %19[%20 : i64] : vector<4xf64>
    %22 = llvm.mlir.constant(3 : i64) : i64
    %23 = llvm.insertelement %arg3, %21[%22 : i64] : vector<4xf64>
    %24 = llvm.extractelement %23[%8 : i64] : vector<4xf64>
    %25 = llvm.extractelement %23[%9 : i64] : vector<4xf64>
    %26 = llvm.extractelement %23[%10 : i64] : vector<4xf64>
    %27 = llvm.fmul %24, %24 : f64
    %28 = llvm.fmul %25, %25 : f64
    %29 = llvm.fmul %26, %26 : f64
    %30 = llvm.fadd %27, %28 : f64
    %31 = llvm.fadd %30, %29 : f64
    %32 = llvm.fcmp "olt" %31, %11 : f64
    %33 = llvm.select %32, %11, %31 : i1, f64
    %34 = llvm.intr.sqrt(%33) : (f64) -> f64
    %35 = llvm.fdiv %7, %34 : f64
    %36 = llvm.fdiv %24, %34 : f64
    %37 = llvm.fdiv %25, %34 : f64
    %38 = llvm.fdiv %26, %34 : f64
    %39 = llvm.fmul %35, %12 : f64
    %40 = llvm.fadd %39, %13 : f64
    %41 = llvm.fmul %39, %36 : f64
    %42 = llvm.fmul %39, %37 : f64
    %43 = llvm.fmul %39, %38 : f64
    %44 = llvm.fmul %36, %36 : f64
    %45 = llvm.fmul %36, %37 : f64
    %46 = llvm.fmul %36, %38 : f64
    %47 = llvm.fmul %37, %37 : f64
    %48 = llvm.fmul %37, %38 : f64
    %49 = llvm.fmul %38, %38 : f64
    %50 = llvm.fmul %39, %44 : f64
    %51 = llvm.fmul %39, %45 : f64
    %52 = llvm.fmul %39, %46 : f64
    %53 = llvm.fmul %39, %47 : f64
    %54 = llvm.fmul %39, %48 : f64
    %55 = llvm.fmul %39, %49 : f64
    %56 = llvm.fadd %50, %7 : f64
    %57 = llvm.fadd %53, %7 : f64
    %58 = llvm.fadd %55, %7 : f64
    %59 = llvm.getelementptr %4[16] : (!llvm.ptr) -> !llvm.ptr, f64
    %60 = llvm.ptrtoint %59 : !llvm.ptr to i64
    %61 = llvm.add %60, %3 : i64
    %62 = llvm.call @malloc(%61) : (i64) -> !llvm.ptr
    %63 = llvm.ptrtoint %62 : !llvm.ptr to i64
    %64 = llvm.sub %3, %5 : i64
    %65 = llvm.add %63, %64 : i64
    %66 = llvm.urem %65, %3 : i64
    %67 = llvm.sub %65, %66 : i64
    %68 = llvm.inttoptr %67 : i64 to !llvm.ptr
    %69 = llvm.mul %14, %6 : i64
    %70 = llvm.add %69, %14 : i64
    %71 = llvm.getelementptr %68[%70] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %40, %71 : f64, !llvm.ptr
    %72 = llvm.mul %14, %6 : i64
    %73 = llvm.add %72, %8 : i64
    %74 = llvm.getelementptr %68[%73] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %41, %74 : f64, !llvm.ptr
    %75 = llvm.mul %14, %6 : i64
    %76 = llvm.add %75, %9 : i64
    %77 = llvm.getelementptr %68[%76] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %42, %77 : f64, !llvm.ptr
    %78 = llvm.mul %14, %6 : i64
    %79 = llvm.add %78, %10 : i64
    %80 = llvm.getelementptr %68[%79] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %43, %80 : f64, !llvm.ptr
    %81 = llvm.mul %8, %6 : i64
    %82 = llvm.add %81, %14 : i64
    %83 = llvm.getelementptr %68[%82] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %41, %83 : f64, !llvm.ptr
    %84 = llvm.mul %8, %6 : i64
    %85 = llvm.add %84, %8 : i64
    %86 = llvm.getelementptr %68[%85] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %56, %86 : f64, !llvm.ptr
    %87 = llvm.mul %8, %6 : i64
    %88 = llvm.add %87, %9 : i64
    %89 = llvm.getelementptr %68[%88] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %51, %89 : f64, !llvm.ptr
    %90 = llvm.mul %8, %6 : i64
    %91 = llvm.add %90, %10 : i64
    %92 = llvm.getelementptr %68[%91] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %52, %92 : f64, !llvm.ptr
    %93 = llvm.mul %9, %6 : i64
    %94 = llvm.add %93, %14 : i64
    %95 = llvm.getelementptr %68[%94] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %42, %95 : f64, !llvm.ptr
    %96 = llvm.mul %9, %6 : i64
    %97 = llvm.add %96, %8 : i64
    %98 = llvm.getelementptr %68[%97] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %51, %98 : f64, !llvm.ptr
    %99 = llvm.mul %9, %6 : i64
    %100 = llvm.add %99, %9 : i64
    %101 = llvm.getelementptr %68[%100] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %57, %101 : f64, !llvm.ptr
    %102 = llvm.mul %9, %6 : i64
    %103 = llvm.add %102, %10 : i64
    %104 = llvm.getelementptr %68[%103] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %54, %104 : f64, !llvm.ptr
    %105 = llvm.mul %10, %6 : i64
    %106 = llvm.add %105, %14 : i64
    %107 = llvm.getelementptr %68[%106] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %43, %107 : f64, !llvm.ptr
    %108 = llvm.mul %10, %6 : i64
    %109 = llvm.add %108, %8 : i64
    %110 = llvm.getelementptr %68[%109] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %52, %110 : f64, !llvm.ptr
    %111 = llvm.mul %10, %6 : i64
    %112 = llvm.add %111, %9 : i64
    %113 = llvm.getelementptr %68[%112] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %54, %113 : f64, !llvm.ptr
    %114 = llvm.mul %10, %6 : i64
    %115 = llvm.add %114, %10 : i64
    %116 = llvm.getelementptr %68[%115] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %58, %116 : f64, !llvm.ptr
    %117 = llvm.getelementptr %4[9] : (!llvm.ptr) -> !llvm.ptr, f64
    %118 = llvm.ptrtoint %117 : !llvm.ptr to i64
    %119 = llvm.add %118, %3 : i64
    %120 = llvm.call @malloc(%119) : (i64) -> !llvm.ptr
    %121 = llvm.ptrtoint %120 : !llvm.ptr to i64
    %122 = llvm.sub %3, %5 : i64
    %123 = llvm.add %121, %122 : i64
    %124 = llvm.urem %123, %3 : i64
    %125 = llvm.sub %123, %124 : i64
    %126 = llvm.inttoptr %125 : i64 to !llvm.ptr
    %127 = llvm.insertvalue %120, %2[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %128 = llvm.insertvalue %126, %127[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %129 = llvm.insertvalue %1, %128[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %130 = llvm.insertvalue %0, %129[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %131 = llvm.insertvalue %0, %130[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %132 = llvm.insertvalue %0, %131[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %133 = llvm.insertvalue %5, %132[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.br ^bb1(%14 : i64)
  ^bb1(%134: i64):  // 2 preds: ^bb0, ^bb5
    %135 = llvm.icmp "slt" %134, %10 : i64
    llvm.cond_br %135, ^bb2, ^bb6
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%14 : i64)
  ^bb3(%136: i64):  // 2 preds: ^bb2, ^bb4
    %137 = llvm.icmp "slt" %136, %10 : i64
    llvm.cond_br %137, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %138 = llvm.getelementptr %68[5] : (!llvm.ptr) -> !llvm.ptr, f64
    %139 = llvm.mul %134, %6 : i64
    %140 = llvm.add %139, %136 : i64
    %141 = llvm.getelementptr %138[%140] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %142 = llvm.load %141 : !llvm.ptr -> f64
    %143 = llvm.mul %134, %0 : i64
    %144 = llvm.add %143, %136 : i64
    %145 = llvm.getelementptr %126[%144] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %142, %145 : f64, !llvm.ptr
    %146 = llvm.add %136, %8 : i64
    llvm.br ^bb3(%146 : i64)
  ^bb5:  // pred: ^bb3
    %147 = llvm.add %134, %8 : i64
    llvm.br ^bb1(%147 : i64)
  ^bb6:  // pred: ^bb1
    llvm.return %133 : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
  }
  llvm.func @_mlir_ciface_SchwarzschildSpatial(%arg0: !llvm.ptr, %arg1: f64, %arg2: f64, %arg3: f64, %arg4: f64) attributes {llvm.emit_c_interface} {
    %0 = llvm.call @SchwarzschildSpatial(%arg1, %arg2, %arg3, %arg4) : (f64, f64, f64, f64) -> !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    llvm.store %0, %arg0 : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>, !llvm.ptr
    llvm.return
  }
  llvm.func @DetInvGamma(%arg0: f64, %arg1: f64, %arg2: f64, %arg3: f64) -> !llvm.struct<(f64, struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>)> attributes {llvm.emit_c_interface} {
    %0 = llvm.mlir.undef : !llvm.struct<(f64, struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>)>
    %1 = llvm.mlir.constant(0 : index) : i64
    %2 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %3 = llvm.mlir.constant(64 : index) : i64
    %4 = llvm.mlir.zero : !llvm.ptr
    %5 = llvm.mlir.constant(1 : index) : i64
    %6 = llvm.mlir.constant(3 : index) : i64
    %7 = llvm.mlir.constant(0 : index) : i64
    %8 = llvm.mlir.constant(1 : index) : i64
    %9 = llvm.mlir.constant(1.000000e-18 : f64) : f64
    %10 = llvm.mlir.constant(1.000000e+00 : f64) : f64
    %11 = llvm.mlir.constant(0.000000e+00 : f64) : f64
    %12 = llvm.mlir.constant(2 : index) : i64
    %13 = llvm.call @SchwarzschildSpatial(%arg0, %arg1, %arg2, %arg3) : (f64, f64, f64, f64) -> !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %14 = llvm.extractvalue %13[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %15 = llvm.mul %7, %6 : i64
    %16 = llvm.add %15, %7 : i64
    %17 = llvm.getelementptr %14[%16] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %18 = llvm.load %17 : !llvm.ptr -> f64
    %19 = llvm.extractvalue %13[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %20 = llvm.mul %7, %6 : i64
    %21 = llvm.add %20, %8 : i64
    %22 = llvm.getelementptr %19[%21] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %23 = llvm.load %22 : !llvm.ptr -> f64
    %24 = llvm.extractvalue %13[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %25 = llvm.mul %7, %6 : i64
    %26 = llvm.add %25, %12 : i64
    %27 = llvm.getelementptr %24[%26] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %28 = llvm.load %27 : !llvm.ptr -> f64
    %29 = llvm.extractvalue %13[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %30 = llvm.mul %8, %6 : i64
    %31 = llvm.add %30, %7 : i64
    %32 = llvm.getelementptr %29[%31] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %33 = llvm.load %32 : !llvm.ptr -> f64
    %34 = llvm.extractvalue %13[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %35 = llvm.mul %8, %6 : i64
    %36 = llvm.add %35, %8 : i64
    %37 = llvm.getelementptr %34[%36] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %38 = llvm.load %37 : !llvm.ptr -> f64
    %39 = llvm.extractvalue %13[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %40 = llvm.mul %8, %6 : i64
    %41 = llvm.add %40, %12 : i64
    %42 = llvm.getelementptr %39[%41] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %43 = llvm.load %42 : !llvm.ptr -> f64
    %44 = llvm.extractvalue %13[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %45 = llvm.mul %12, %6 : i64
    %46 = llvm.add %45, %7 : i64
    %47 = llvm.getelementptr %44[%46] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %48 = llvm.load %47 : !llvm.ptr -> f64
    %49 = llvm.extractvalue %13[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %50 = llvm.mul %12, %6 : i64
    %51 = llvm.add %50, %8 : i64
    %52 = llvm.getelementptr %49[%51] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %53 = llvm.load %52 : !llvm.ptr -> f64
    %54 = llvm.extractvalue %13[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %55 = llvm.mul %12, %6 : i64
    %56 = llvm.add %55, %12 : i64
    %57 = llvm.getelementptr %54[%56] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %58 = llvm.load %57 : !llvm.ptr -> f64
    %59 = llvm.fmul %38, %58 : f64
    %60 = llvm.fmul %43, %53 : f64
    %61 = llvm.fsub %59, %60 : f64
    %62 = llvm.fmul %33, %58 : f64
    %63 = llvm.fmul %43, %48 : f64
    %64 = llvm.fsub %62, %63 : f64
    %65 = llvm.fneg %64 : f64
    %66 = llvm.fmul %33, %53 : f64
    %67 = llvm.fmul %38, %48 : f64
    %68 = llvm.fsub %66, %67 : f64
    %69 = llvm.fmul %18, %61 : f64
    %70 = llvm.fmul %23, %65 : f64
    %71 = llvm.fadd %69, %70 : f64
    %72 = llvm.fmul %28, %68 : f64
    %73 = llvm.fadd %71, %72 : f64
    %74 = llvm.extractvalue %13[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %75 = llvm.mul %7, %6 : i64
    %76 = llvm.add %75, %7 : i64
    %77 = llvm.getelementptr %74[%76] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %78 = llvm.load %77 : !llvm.ptr -> f64
    %79 = llvm.extractvalue %13[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %80 = llvm.mul %7, %6 : i64
    %81 = llvm.add %80, %8 : i64
    %82 = llvm.getelementptr %79[%81] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %83 = llvm.load %82 : !llvm.ptr -> f64
    %84 = llvm.extractvalue %13[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %85 = llvm.mul %7, %6 : i64
    %86 = llvm.add %85, %12 : i64
    %87 = llvm.getelementptr %84[%86] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %88 = llvm.load %87 : !llvm.ptr -> f64
    %89 = llvm.extractvalue %13[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %90 = llvm.mul %8, %6 : i64
    %91 = llvm.add %90, %7 : i64
    %92 = llvm.getelementptr %89[%91] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %93 = llvm.load %92 : !llvm.ptr -> f64
    %94 = llvm.extractvalue %13[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %95 = llvm.mul %8, %6 : i64
    %96 = llvm.add %95, %8 : i64
    %97 = llvm.getelementptr %94[%96] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %98 = llvm.load %97 : !llvm.ptr -> f64
    %99 = llvm.extractvalue %13[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %100 = llvm.mul %8, %6 : i64
    %101 = llvm.add %100, %12 : i64
    %102 = llvm.getelementptr %99[%101] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %103 = llvm.load %102 : !llvm.ptr -> f64
    %104 = llvm.extractvalue %13[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %105 = llvm.mul %12, %6 : i64
    %106 = llvm.add %105, %7 : i64
    %107 = llvm.getelementptr %104[%106] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %108 = llvm.load %107 : !llvm.ptr -> f64
    %109 = llvm.extractvalue %13[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %110 = llvm.mul %12, %6 : i64
    %111 = llvm.add %110, %8 : i64
    %112 = llvm.getelementptr %109[%111] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %113 = llvm.load %112 : !llvm.ptr -> f64
    %114 = llvm.extractvalue %13[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %115 = llvm.mul %12, %6 : i64
    %116 = llvm.add %115, %12 : i64
    %117 = llvm.getelementptr %114[%116] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %118 = llvm.load %117 : !llvm.ptr -> f64
    %119 = llvm.fmul %98, %118 : f64
    %120 = llvm.fmul %103, %113 : f64
    %121 = llvm.fsub %119, %120 : f64
    %122 = llvm.fmul %93, %118 : f64
    %123 = llvm.fmul %103, %108 : f64
    %124 = llvm.fsub %122, %123 : f64
    %125 = llvm.fneg %124 : f64
    %126 = llvm.fmul %93, %113 : f64
    %127 = llvm.fmul %98, %108 : f64
    %128 = llvm.fsub %126, %127 : f64
    %129 = llvm.fmul %83, %118 : f64
    %130 = llvm.fmul %88, %113 : f64
    %131 = llvm.fsub %129, %130 : f64
    %132 = llvm.fneg %131 : f64
    %133 = llvm.fmul %78, %118 : f64
    %134 = llvm.fmul %88, %108 : f64
    %135 = llvm.fsub %133, %134 : f64
    %136 = llvm.fmul %78, %113 : f64
    %137 = llvm.fmul %83, %108 : f64
    %138 = llvm.fsub %136, %137 : f64
    %139 = llvm.fneg %138 : f64
    %140 = llvm.fmul %83, %103 : f64
    %141 = llvm.fmul %88, %98 : f64
    %142 = llvm.fsub %140, %141 : f64
    %143 = llvm.fmul %78, %103 : f64
    %144 = llvm.fmul %88, %93 : f64
    %145 = llvm.fsub %143, %144 : f64
    %146 = llvm.fneg %145 : f64
    %147 = llvm.fmul %78, %98 : f64
    %148 = llvm.fmul %83, %93 : f64
    %149 = llvm.fsub %147, %148 : f64
    %150 = llvm.fmul %78, %121 : f64
    %151 = llvm.fmul %83, %125 : f64
    %152 = llvm.fadd %150, %151 : f64
    %153 = llvm.fmul %88, %128 : f64
    %154 = llvm.fadd %152, %153 : f64
    %155 = llvm.fcmp "olt" %154, %11 : f64
    %156 = llvm.fneg %154 : f64
    %157 = llvm.select %155, %156, %154 : i1, f64
    %158 = llvm.fcmp "oge" %157, %9 : f64
    %159 = llvm.select %158, %157, %9 : i1, f64
    %160 = llvm.fdiv %10, %159 : f64
    %161 = llvm.fneg %160 : f64
    %162 = llvm.select %155, %161, %160 : i1, f64
    %163 = llvm.getelementptr %4[9] : (!llvm.ptr) -> !llvm.ptr, f64
    %164 = llvm.ptrtoint %163 : !llvm.ptr to i64
    %165 = llvm.add %164, %3 : i64
    %166 = llvm.call @malloc(%165) : (i64) -> !llvm.ptr
    %167 = llvm.ptrtoint %166 : !llvm.ptr to i64
    %168 = llvm.sub %3, %5 : i64
    %169 = llvm.add %167, %168 : i64
    %170 = llvm.urem %169, %3 : i64
    %171 = llvm.sub %169, %170 : i64
    %172 = llvm.inttoptr %171 : i64 to !llvm.ptr
    %173 = llvm.insertvalue %166, %2[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %174 = llvm.insertvalue %172, %173[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %175 = llvm.insertvalue %1, %174[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %176 = llvm.insertvalue %6, %175[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %177 = llvm.insertvalue %6, %176[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %178 = llvm.insertvalue %6, %177[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %179 = llvm.insertvalue %5, %178[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %180 = llvm.fmul %121, %162 : f64
    %181 = llvm.mul %7, %6 : i64
    %182 = llvm.add %181, %7 : i64
    %183 = llvm.getelementptr %172[%182] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %180, %183 : f64, !llvm.ptr
    %184 = llvm.fmul %132, %162 : f64
    %185 = llvm.mul %7, %6 : i64
    %186 = llvm.add %185, %8 : i64
    %187 = llvm.getelementptr %172[%186] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %184, %187 : f64, !llvm.ptr
    %188 = llvm.fmul %142, %162 : f64
    %189 = llvm.mul %7, %6 : i64
    %190 = llvm.add %189, %12 : i64
    %191 = llvm.getelementptr %172[%190] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %188, %191 : f64, !llvm.ptr
    %192 = llvm.fmul %125, %162 : f64
    %193 = llvm.mul %8, %6 : i64
    %194 = llvm.add %193, %7 : i64
    %195 = llvm.getelementptr %172[%194] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %192, %195 : f64, !llvm.ptr
    %196 = llvm.fmul %135, %162 : f64
    %197 = llvm.mul %8, %6 : i64
    %198 = llvm.add %197, %8 : i64
    %199 = llvm.getelementptr %172[%198] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %196, %199 : f64, !llvm.ptr
    %200 = llvm.fmul %146, %162 : f64
    %201 = llvm.mul %8, %6 : i64
    %202 = llvm.add %201, %12 : i64
    %203 = llvm.getelementptr %172[%202] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %200, %203 : f64, !llvm.ptr
    %204 = llvm.fmul %128, %162 : f64
    %205 = llvm.mul %12, %6 : i64
    %206 = llvm.add %205, %7 : i64
    %207 = llvm.getelementptr %172[%206] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %204, %207 : f64, !llvm.ptr
    %208 = llvm.fmul %139, %162 : f64
    %209 = llvm.mul %12, %6 : i64
    %210 = llvm.add %209, %8 : i64
    %211 = llvm.getelementptr %172[%210] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %208, %211 : f64, !llvm.ptr
    %212 = llvm.fmul %149, %162 : f64
    %213 = llvm.mul %12, %6 : i64
    %214 = llvm.add %213, %12 : i64
    %215 = llvm.getelementptr %172[%214] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %212, %215 : f64, !llvm.ptr
    %216 = llvm.insertvalue %73, %0[0] : !llvm.struct<(f64, struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>)> 
    %217 = llvm.insertvalue %179, %216[1] : !llvm.struct<(f64, struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>)> 
    llvm.return %217 : !llvm.struct<(f64, struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>)>
  }
  llvm.func @_mlir_ciface_DetInvGamma(%arg0: !llvm.ptr, %arg1: f64, %arg2: f64, %arg3: f64, %arg4: f64) attributes {llvm.emit_c_interface} {
    %0 = llvm.call @DetInvGamma(%arg1, %arg2, %arg3, %arg4) : (f64, f64, f64, f64) -> !llvm.struct<(f64, struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>)>
    llvm.store %0, %arg0 : !llvm.struct<(f64, struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>)>, !llvm.ptr
    llvm.return
  }
}

