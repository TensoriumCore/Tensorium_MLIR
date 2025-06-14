module {
  llvm.func @malloc(i64) -> !llvm.ptr
  llvm.func @schwarzschild_tensor(%arg0: f64, %arg1: f64, %arg2: f64, %arg3: f64) -> !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> {
    %0 = llvm.mlir.constant(3 : index) : i64
    %1 = llvm.mlir.constant(2 : index) : i64
    %2 = llvm.mlir.constant(1 : index) : i64
    %3 = llvm.mlir.constant(0 : index) : i64
    %4 = llvm.mlir.constant(-1.000000e+00 : f64) : f64
    %5 = llvm.mlir.constant(1.000000e+00 : f64) : f64
    %6 = llvm.mlir.constant(0.000000e+00 : f64) : f64
    %7 = llvm.mlir.constant(4 : index) : i64
    %8 = llvm.mlir.constant(4 : index) : i64
    %9 = llvm.mlir.constant(1 : index) : i64
    %10 = llvm.mlir.constant(16 : index) : i64
    %11 = llvm.mlir.zero : !llvm.ptr
    %12 = llvm.getelementptr %11[%10] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %13 = llvm.ptrtoint %12 : !llvm.ptr to i64
    %14 = llvm.call @malloc(%13) : (i64) -> !llvm.ptr
    %15 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %16 = llvm.insertvalue %14, %15[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %17 = llvm.insertvalue %14, %16[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %18 = llvm.mlir.constant(0 : index) : i64
    %19 = llvm.insertvalue %18, %17[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %20 = llvm.insertvalue %7, %19[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %21 = llvm.insertvalue %8, %20[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %22 = llvm.insertvalue %8, %21[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.insertvalue %9, %22[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %24 = llvm.fdiv %5, %arg1 : f64
    %25 = llvm.fmul %arg1, %4 : f64
    %26 = llvm.fadd %25, %6 : f64
    %27 = llvm.fmul %24, %26 : f64
    %28 = llvm.fadd %27, %6 : f64
    %29 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %30 = llvm.mlir.constant(4 : index) : i64
    %31 = llvm.mul %3, %30 overflow<nsw, nuw> : i64
    %32 = llvm.add %31, %3 overflow<nsw, nuw> : i64
    %33 = llvm.getelementptr inbounds|nuw %29[%32] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %28, %33 : f64, !llvm.ptr
    %34 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %35 = llvm.mlir.constant(4 : index) : i64
    %36 = llvm.mul %3, %35 overflow<nsw, nuw> : i64
    %37 = llvm.add %36, %2 overflow<nsw, nuw> : i64
    %38 = llvm.getelementptr inbounds|nuw %34[%37] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %38 : f64, !llvm.ptr
    %39 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %40 = llvm.mlir.constant(4 : index) : i64
    %41 = llvm.mul %3, %40 overflow<nsw, nuw> : i64
    %42 = llvm.add %41, %1 overflow<nsw, nuw> : i64
    %43 = llvm.getelementptr inbounds|nuw %39[%42] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %43 : f64, !llvm.ptr
    %44 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %45 = llvm.mlir.constant(4 : index) : i64
    %46 = llvm.mul %3, %45 overflow<nsw, nuw> : i64
    %47 = llvm.add %46, %0 overflow<nsw, nuw> : i64
    %48 = llvm.getelementptr inbounds|nuw %44[%47] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %48 : f64, !llvm.ptr
    %49 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %50 = llvm.mlir.constant(4 : index) : i64
    %51 = llvm.mul %2, %50 overflow<nsw, nuw> : i64
    %52 = llvm.add %51, %3 overflow<nsw, nuw> : i64
    %53 = llvm.getelementptr inbounds|nuw %49[%52] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %53 : f64, !llvm.ptr
    %54 = llvm.fdiv %5, %arg1 : f64
    %55 = llvm.fmul %arg1, %54 : f64
    %56 = llvm.fadd %55, %6 : f64
    %57 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %58 = llvm.mlir.constant(4 : index) : i64
    %59 = llvm.mul %2, %58 overflow<nsw, nuw> : i64
    %60 = llvm.add %59, %2 overflow<nsw, nuw> : i64
    %61 = llvm.getelementptr inbounds|nuw %57[%60] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %56, %61 : f64, !llvm.ptr
    %62 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %63 = llvm.mlir.constant(4 : index) : i64
    %64 = llvm.mul %2, %63 overflow<nsw, nuw> : i64
    %65 = llvm.add %64, %1 overflow<nsw, nuw> : i64
    %66 = llvm.getelementptr inbounds|nuw %62[%65] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %66 : f64, !llvm.ptr
    %67 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %68 = llvm.mlir.constant(4 : index) : i64
    %69 = llvm.mul %2, %68 overflow<nsw, nuw> : i64
    %70 = llvm.add %69, %0 overflow<nsw, nuw> : i64
    %71 = llvm.getelementptr inbounds|nuw %67[%70] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %71 : f64, !llvm.ptr
    %72 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %73 = llvm.mlir.constant(4 : index) : i64
    %74 = llvm.mul %1, %73 overflow<nsw, nuw> : i64
    %75 = llvm.add %74, %3 overflow<nsw, nuw> : i64
    %76 = llvm.getelementptr inbounds|nuw %72[%75] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %76 : f64, !llvm.ptr
    %77 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %78 = llvm.mlir.constant(4 : index) : i64
    %79 = llvm.mul %1, %78 overflow<nsw, nuw> : i64
    %80 = llvm.add %79, %2 overflow<nsw, nuw> : i64
    %81 = llvm.getelementptr inbounds|nuw %77[%80] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %81 : f64, !llvm.ptr
    %82 = llvm.fmul %arg1, %arg1 : f64
    %83 = llvm.fadd %82, %6 : f64
    %84 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %85 = llvm.mlir.constant(4 : index) : i64
    %86 = llvm.mul %1, %85 overflow<nsw, nuw> : i64
    %87 = llvm.add %86, %1 overflow<nsw, nuw> : i64
    %88 = llvm.getelementptr inbounds|nuw %84[%87] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %83, %88 : f64, !llvm.ptr
    %89 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %90 = llvm.mlir.constant(4 : index) : i64
    %91 = llvm.mul %1, %90 overflow<nsw, nuw> : i64
    %92 = llvm.add %91, %0 overflow<nsw, nuw> : i64
    %93 = llvm.getelementptr inbounds|nuw %89[%92] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %93 : f64, !llvm.ptr
    %94 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %95 = llvm.mlir.constant(4 : index) : i64
    %96 = llvm.mul %0, %95 overflow<nsw, nuw> : i64
    %97 = llvm.add %96, %3 overflow<nsw, nuw> : i64
    %98 = llvm.getelementptr inbounds|nuw %94[%97] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %98 : f64, !llvm.ptr
    %99 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %100 = llvm.mlir.constant(4 : index) : i64
    %101 = llvm.mul %0, %100 overflow<nsw, nuw> : i64
    %102 = llvm.add %101, %2 overflow<nsw, nuw> : i64
    %103 = llvm.getelementptr inbounds|nuw %99[%102] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %103 : f64, !llvm.ptr
    %104 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %105 = llvm.mlir.constant(4 : index) : i64
    %106 = llvm.mul %0, %105 overflow<nsw, nuw> : i64
    %107 = llvm.add %106, %1 overflow<nsw, nuw> : i64
    %108 = llvm.getelementptr inbounds|nuw %104[%107] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %108 : f64, !llvm.ptr
    %109 = llvm.fmul %arg1, %arg1 : f64
    %110 = llvm.intr.sin(%arg2) : (f64) -> f64
    %111 = llvm.intr.sin(%arg2) : (f64) -> f64
    %112 = llvm.fmul %110, %111 : f64
    %113 = llvm.fmul %109, %112 : f64
    %114 = llvm.fadd %113, %6 : f64
    %115 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %116 = llvm.mlir.constant(4 : index) : i64
    %117 = llvm.mul %0, %116 overflow<nsw, nuw> : i64
    %118 = llvm.add %117, %0 overflow<nsw, nuw> : i64
    %119 = llvm.getelementptr inbounds|nuw %115[%118] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %114, %119 : f64, !llvm.ptr
    llvm.return %23 : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
  }
}

