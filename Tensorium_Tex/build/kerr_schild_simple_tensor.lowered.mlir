module {
  llvm.func @malloc(i64) -> !llvm.ptr
  llvm.func @kerr_schild_simple_tensor(%arg0: f64, %arg1: f64, %arg2: f64, %arg3: f64) -> !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> {
    %0 = llvm.mlir.constant(0x7FF0000000000000 : f64) : f64
    %1 = llvm.mlir.constant(3 : index) : i64
    %2 = llvm.mlir.constant(2 : index) : i64
    %3 = llvm.mlir.constant(1 : index) : i64
    %4 = llvm.mlir.constant(0 : index) : i64
    %5 = llvm.mlir.constant(0.000000e+00 : f64) : f64
    %6 = llvm.mlir.constant(4 : index) : i64
    %7 = llvm.mlir.constant(4 : index) : i64
    %8 = llvm.mlir.constant(1 : index) : i64
    %9 = llvm.mlir.constant(16 : index) : i64
    %10 = llvm.mlir.zero : !llvm.ptr
    %11 = llvm.getelementptr %10[%9] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %12 = llvm.ptrtoint %11 : !llvm.ptr to i64
    %13 = llvm.call @malloc(%12) : (i64) -> !llvm.ptr
    %14 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %15 = llvm.insertvalue %13, %14[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %16 = llvm.insertvalue %13, %15[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %17 = llvm.mlir.constant(0 : index) : i64
    %18 = llvm.insertvalue %17, %16[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %19 = llvm.insertvalue %6, %18[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %20 = llvm.insertvalue %7, %19[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %21 = llvm.insertvalue %7, %20[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %22 = llvm.insertvalue %8, %21[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.fmul %arg1, %arg1 : f64
    %24 = llvm.fmul %23, %arg1 : f64
    %25 = llvm.fmul %24, %5 : f64
    %26 = llvm.fmul %25, %0 : f64
    %27 = llvm.fadd %26, %5 : f64
    %28 = llvm.extractvalue %22[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %29 = llvm.mlir.constant(4 : index) : i64
    %30 = llvm.mul %4, %29 overflow<nsw, nuw> : i64
    %31 = llvm.add %30, %4 overflow<nsw, nuw> : i64
    %32 = llvm.getelementptr inbounds|nuw %28[%31] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %27, %32 : f64, !llvm.ptr
    %33 = llvm.extractvalue %22[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %34 = llvm.mlir.constant(4 : index) : i64
    %35 = llvm.mul %4, %34 overflow<nsw, nuw> : i64
    %36 = llvm.add %35, %3 overflow<nsw, nuw> : i64
    %37 = llvm.getelementptr inbounds|nuw %33[%36] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %5, %37 : f64, !llvm.ptr
    %38 = llvm.extractvalue %22[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %39 = llvm.mlir.constant(4 : index) : i64
    %40 = llvm.mul %4, %39 overflow<nsw, nuw> : i64
    %41 = llvm.add %40, %2 overflow<nsw, nuw> : i64
    %42 = llvm.getelementptr inbounds|nuw %38[%41] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %5, %42 : f64, !llvm.ptr
    %43 = llvm.extractvalue %22[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %44 = llvm.mlir.constant(4 : index) : i64
    %45 = llvm.mul %4, %44 overflow<nsw, nuw> : i64
    %46 = llvm.add %45, %1 overflow<nsw, nuw> : i64
    %47 = llvm.getelementptr inbounds|nuw %43[%46] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %5, %47 : f64, !llvm.ptr
    %48 = llvm.extractvalue %22[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %49 = llvm.mlir.constant(4 : index) : i64
    %50 = llvm.mul %3, %49 overflow<nsw, nuw> : i64
    %51 = llvm.add %50, %4 overflow<nsw, nuw> : i64
    %52 = llvm.getelementptr inbounds|nuw %48[%51] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %5, %52 : f64, !llvm.ptr
    %53 = llvm.extractvalue %22[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %54 = llvm.mlir.constant(4 : index) : i64
    %55 = llvm.mul %3, %54 overflow<nsw, nuw> : i64
    %56 = llvm.add %55, %3 overflow<nsw, nuw> : i64
    %57 = llvm.getelementptr inbounds|nuw %53[%56] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %5, %57 : f64, !llvm.ptr
    %58 = llvm.extractvalue %22[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %59 = llvm.mlir.constant(4 : index) : i64
    %60 = llvm.mul %3, %59 overflow<nsw, nuw> : i64
    %61 = llvm.add %60, %2 overflow<nsw, nuw> : i64
    %62 = llvm.getelementptr inbounds|nuw %58[%61] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %5, %62 : f64, !llvm.ptr
    %63 = llvm.extractvalue %22[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %64 = llvm.mlir.constant(4 : index) : i64
    %65 = llvm.mul %3, %64 overflow<nsw, nuw> : i64
    %66 = llvm.add %65, %1 overflow<nsw, nuw> : i64
    %67 = llvm.getelementptr inbounds|nuw %63[%66] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %5, %67 : f64, !llvm.ptr
    %68 = llvm.extractvalue %22[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %69 = llvm.mlir.constant(4 : index) : i64
    %70 = llvm.mul %2, %69 overflow<nsw, nuw> : i64
    %71 = llvm.add %70, %4 overflow<nsw, nuw> : i64
    %72 = llvm.getelementptr inbounds|nuw %68[%71] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %5, %72 : f64, !llvm.ptr
    %73 = llvm.extractvalue %22[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %74 = llvm.mlir.constant(4 : index) : i64
    %75 = llvm.mul %2, %74 overflow<nsw, nuw> : i64
    %76 = llvm.add %75, %3 overflow<nsw, nuw> : i64
    %77 = llvm.getelementptr inbounds|nuw %73[%76] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %5, %77 : f64, !llvm.ptr
    %78 = llvm.extractvalue %22[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %79 = llvm.mlir.constant(4 : index) : i64
    %80 = llvm.mul %2, %79 overflow<nsw, nuw> : i64
    %81 = llvm.add %80, %2 overflow<nsw, nuw> : i64
    %82 = llvm.getelementptr inbounds|nuw %78[%81] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %5, %82 : f64, !llvm.ptr
    %83 = llvm.extractvalue %22[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %84 = llvm.mlir.constant(4 : index) : i64
    %85 = llvm.mul %2, %84 overflow<nsw, nuw> : i64
    %86 = llvm.add %85, %1 overflow<nsw, nuw> : i64
    %87 = llvm.getelementptr inbounds|nuw %83[%86] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %5, %87 : f64, !llvm.ptr
    %88 = llvm.extractvalue %22[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %89 = llvm.mlir.constant(4 : index) : i64
    %90 = llvm.mul %1, %89 overflow<nsw, nuw> : i64
    %91 = llvm.add %90, %4 overflow<nsw, nuw> : i64
    %92 = llvm.getelementptr inbounds|nuw %88[%91] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %5, %92 : f64, !llvm.ptr
    %93 = llvm.extractvalue %22[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %94 = llvm.mlir.constant(4 : index) : i64
    %95 = llvm.mul %1, %94 overflow<nsw, nuw> : i64
    %96 = llvm.add %95, %3 overflow<nsw, nuw> : i64
    %97 = llvm.getelementptr inbounds|nuw %93[%96] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %5, %97 : f64, !llvm.ptr
    %98 = llvm.extractvalue %22[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %99 = llvm.mlir.constant(4 : index) : i64
    %100 = llvm.mul %1, %99 overflow<nsw, nuw> : i64
    %101 = llvm.add %100, %2 overflow<nsw, nuw> : i64
    %102 = llvm.getelementptr inbounds|nuw %98[%101] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %5, %102 : f64, !llvm.ptr
    %103 = llvm.extractvalue %22[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %104 = llvm.mlir.constant(4 : index) : i64
    %105 = llvm.mul %1, %104 overflow<nsw, nuw> : i64
    %106 = llvm.add %105, %1 overflow<nsw, nuw> : i64
    %107 = llvm.getelementptr inbounds|nuw %103[%106] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %5, %107 : f64, !llvm.ptr
    llvm.return %22 : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
  }
}

