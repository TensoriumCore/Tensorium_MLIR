module {
  llvm.func @malloc(i64) -> !llvm.ptr
  llvm.func @schwarzschild_tensor(%arg0: f64, %arg1: f64, %arg2: f64, %arg3: f64, %arg4: f64, %arg5: f64) -> !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> {
    %0 = llvm.mlir.constant(-2.000000e+00 : f64) : f64
    %1 = llvm.mlir.constant(3 : index) : i64
    %2 = llvm.mlir.constant(2 : index) : i64
    %3 = llvm.mlir.constant(1 : index) : i64
    %4 = llvm.mlir.constant(0 : index) : i64
    %5 = llvm.mlir.constant(2.000000e+00 : f64) : f64
    %6 = llvm.mlir.constant(-1.000000e+00 : f64) : f64
    %7 = llvm.mlir.constant(1.000000e+00 : f64) : f64
    %8 = llvm.mlir.constant(0.000000e+00 : f64) : f64
    %9 = llvm.mlir.constant(4 : index) : i64
    %10 = llvm.mlir.constant(4 : index) : i64
    %11 = llvm.mlir.constant(1 : index) : i64
    %12 = llvm.mlir.constant(16 : index) : i64
    %13 = llvm.mlir.zero : !llvm.ptr
    %14 = llvm.getelementptr %13[%12] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %15 = llvm.ptrtoint %14 : !llvm.ptr to i64
    %16 = llvm.call @malloc(%15) : (i64) -> !llvm.ptr
    %17 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %18 = llvm.insertvalue %16, %17[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %19 = llvm.insertvalue %16, %18[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %20 = llvm.mlir.constant(0 : index) : i64
    %21 = llvm.insertvalue %20, %19[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %22 = llvm.insertvalue %9, %21[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.insertvalue %10, %22[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %24 = llvm.insertvalue %10, %23[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %25 = llvm.insertvalue %11, %24[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %26 = llvm.fdiv %7, %arg1 : f64
    %27 = llvm.fmul %arg1, %6 : f64
    %28 = llvm.fmul %arg4, %5 : f64
    %29 = llvm.fadd %27, %28 : f64
    %30 = llvm.fmul %26, %29 : f64
    %31 = llvm.fadd %30, %8 : f64
    %32 = llvm.extractvalue %25[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %33 = llvm.mlir.constant(4 : index) : i64
    %34 = llvm.mul %4, %33 overflow<nsw, nuw> : i64
    %35 = llvm.add %34, %4 overflow<nsw, nuw> : i64
    %36 = llvm.getelementptr inbounds|nuw %32[%35] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %31, %36 : f64, !llvm.ptr
    %37 = llvm.extractvalue %25[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %38 = llvm.mlir.constant(4 : index) : i64
    %39 = llvm.mul %4, %38 overflow<nsw, nuw> : i64
    %40 = llvm.add %39, %3 overflow<nsw, nuw> : i64
    %41 = llvm.getelementptr inbounds|nuw %37[%40] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %8, %41 : f64, !llvm.ptr
    %42 = llvm.extractvalue %25[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %43 = llvm.mlir.constant(4 : index) : i64
    %44 = llvm.mul %4, %43 overflow<nsw, nuw> : i64
    %45 = llvm.add %44, %2 overflow<nsw, nuw> : i64
    %46 = llvm.getelementptr inbounds|nuw %42[%45] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %8, %46 : f64, !llvm.ptr
    %47 = llvm.extractvalue %25[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %48 = llvm.mlir.constant(4 : index) : i64
    %49 = llvm.mul %4, %48 overflow<nsw, nuw> : i64
    %50 = llvm.add %49, %1 overflow<nsw, nuw> : i64
    %51 = llvm.getelementptr inbounds|nuw %47[%50] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %8, %51 : f64, !llvm.ptr
    %52 = llvm.extractvalue %25[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %53 = llvm.mlir.constant(4 : index) : i64
    %54 = llvm.mul %3, %53 overflow<nsw, nuw> : i64
    %55 = llvm.add %54, %4 overflow<nsw, nuw> : i64
    %56 = llvm.getelementptr inbounds|nuw %52[%55] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %8, %56 : f64, !llvm.ptr
    %57 = llvm.fmul %arg4, %0 : f64
    %58 = llvm.fadd %arg1, %57 : f64
    %59 = llvm.fdiv %7, %58 : f64
    %60 = llvm.fmul %arg1, %59 : f64
    %61 = llvm.fadd %60, %8 : f64
    %62 = llvm.extractvalue %25[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %63 = llvm.mlir.constant(4 : index) : i64
    %64 = llvm.mul %3, %63 overflow<nsw, nuw> : i64
    %65 = llvm.add %64, %3 overflow<nsw, nuw> : i64
    %66 = llvm.getelementptr inbounds|nuw %62[%65] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %61, %66 : f64, !llvm.ptr
    %67 = llvm.extractvalue %25[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %68 = llvm.mlir.constant(4 : index) : i64
    %69 = llvm.mul %3, %68 overflow<nsw, nuw> : i64
    %70 = llvm.add %69, %2 overflow<nsw, nuw> : i64
    %71 = llvm.getelementptr inbounds|nuw %67[%70] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %8, %71 : f64, !llvm.ptr
    %72 = llvm.extractvalue %25[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %73 = llvm.mlir.constant(4 : index) : i64
    %74 = llvm.mul %3, %73 overflow<nsw, nuw> : i64
    %75 = llvm.add %74, %1 overflow<nsw, nuw> : i64
    %76 = llvm.getelementptr inbounds|nuw %72[%75] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %8, %76 : f64, !llvm.ptr
    %77 = llvm.extractvalue %25[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %78 = llvm.mlir.constant(4 : index) : i64
    %79 = llvm.mul %2, %78 overflow<nsw, nuw> : i64
    %80 = llvm.add %79, %4 overflow<nsw, nuw> : i64
    %81 = llvm.getelementptr inbounds|nuw %77[%80] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %8, %81 : f64, !llvm.ptr
    %82 = llvm.extractvalue %25[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %83 = llvm.mlir.constant(4 : index) : i64
    %84 = llvm.mul %2, %83 overflow<nsw, nuw> : i64
    %85 = llvm.add %84, %3 overflow<nsw, nuw> : i64
    %86 = llvm.getelementptr inbounds|nuw %82[%85] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %8, %86 : f64, !llvm.ptr
    %87 = llvm.fmul %arg1, %arg1 : f64
    %88 = llvm.fadd %87, %8 : f64
    %89 = llvm.extractvalue %25[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %90 = llvm.mlir.constant(4 : index) : i64
    %91 = llvm.mul %2, %90 overflow<nsw, nuw> : i64
    %92 = llvm.add %91, %2 overflow<nsw, nuw> : i64
    %93 = llvm.getelementptr inbounds|nuw %89[%92] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %88, %93 : f64, !llvm.ptr
    %94 = llvm.extractvalue %25[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %95 = llvm.mlir.constant(4 : index) : i64
    %96 = llvm.mul %2, %95 overflow<nsw, nuw> : i64
    %97 = llvm.add %96, %1 overflow<nsw, nuw> : i64
    %98 = llvm.getelementptr inbounds|nuw %94[%97] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %8, %98 : f64, !llvm.ptr
    %99 = llvm.extractvalue %25[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %100 = llvm.mlir.constant(4 : index) : i64
    %101 = llvm.mul %1, %100 overflow<nsw, nuw> : i64
    %102 = llvm.add %101, %4 overflow<nsw, nuw> : i64
    %103 = llvm.getelementptr inbounds|nuw %99[%102] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %8, %103 : f64, !llvm.ptr
    %104 = llvm.extractvalue %25[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %105 = llvm.mlir.constant(4 : index) : i64
    %106 = llvm.mul %1, %105 overflow<nsw, nuw> : i64
    %107 = llvm.add %106, %3 overflow<nsw, nuw> : i64
    %108 = llvm.getelementptr inbounds|nuw %104[%107] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %8, %108 : f64, !llvm.ptr
    %109 = llvm.extractvalue %25[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %110 = llvm.mlir.constant(4 : index) : i64
    %111 = llvm.mul %1, %110 overflow<nsw, nuw> : i64
    %112 = llvm.add %111, %2 overflow<nsw, nuw> : i64
    %113 = llvm.getelementptr inbounds|nuw %109[%112] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %8, %113 : f64, !llvm.ptr
    %114 = llvm.fmul %arg1, %arg1 : f64
    %115 = llvm.intr.sin(%arg2) : (f64) -> f64
    %116 = llvm.intr.sin(%arg2) : (f64) -> f64
    %117 = llvm.fmul %115, %116 : f64
    %118 = llvm.fmul %114, %117 : f64
    %119 = llvm.fadd %118, %8 : f64
    %120 = llvm.extractvalue %25[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %121 = llvm.mlir.constant(4 : index) : i64
    %122 = llvm.mul %1, %121 overflow<nsw, nuw> : i64
    %123 = llvm.add %122, %1 overflow<nsw, nuw> : i64
    %124 = llvm.getelementptr inbounds|nuw %120[%123] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %119, %124 : f64, !llvm.ptr
    llvm.return %25 : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
  }
}

