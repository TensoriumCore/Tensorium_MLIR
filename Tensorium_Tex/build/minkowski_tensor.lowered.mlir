module {
  llvm.func @malloc(i64) -> !llvm.ptr
  llvm.func @minkowski_tensor(%arg0: f64, %arg1: f64, %arg2: f64, %arg3: f64, %arg4: f64, %arg5: f64) -> !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> {
    %0 = llvm.mlir.constant(1.000000e+00 : f64) : f64
    %1 = llvm.mlir.constant(-1.000000e+00 : f64) : f64
    %2 = llvm.mlir.constant(3 : index) : i64
    %3 = llvm.mlir.constant(2 : index) : i64
    %4 = llvm.mlir.constant(1 : index) : i64
    %5 = llvm.mlir.constant(0 : index) : i64
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
    %24 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %25 = llvm.mlir.constant(4 : index) : i64
    %26 = llvm.mul %5, %25 overflow<nsw, nuw> : i64
    %27 = llvm.add %26, %5 overflow<nsw, nuw> : i64
    %28 = llvm.getelementptr inbounds|nuw %24[%27] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %1, %28 : f64, !llvm.ptr
    %29 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %30 = llvm.mlir.constant(4 : index) : i64
    %31 = llvm.mul %5, %30 overflow<nsw, nuw> : i64
    %32 = llvm.add %31, %4 overflow<nsw, nuw> : i64
    %33 = llvm.getelementptr inbounds|nuw %29[%32] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %33 : f64, !llvm.ptr
    %34 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %35 = llvm.mlir.constant(4 : index) : i64
    %36 = llvm.mul %5, %35 overflow<nsw, nuw> : i64
    %37 = llvm.add %36, %3 overflow<nsw, nuw> : i64
    %38 = llvm.getelementptr inbounds|nuw %34[%37] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %38 : f64, !llvm.ptr
    %39 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %40 = llvm.mlir.constant(4 : index) : i64
    %41 = llvm.mul %5, %40 overflow<nsw, nuw> : i64
    %42 = llvm.add %41, %2 overflow<nsw, nuw> : i64
    %43 = llvm.getelementptr inbounds|nuw %39[%42] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %43 : f64, !llvm.ptr
    %44 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %45 = llvm.mlir.constant(4 : index) : i64
    %46 = llvm.mul %4, %45 overflow<nsw, nuw> : i64
    %47 = llvm.add %46, %5 overflow<nsw, nuw> : i64
    %48 = llvm.getelementptr inbounds|nuw %44[%47] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %48 : f64, !llvm.ptr
    %49 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %50 = llvm.mlir.constant(4 : index) : i64
    %51 = llvm.mul %4, %50 overflow<nsw, nuw> : i64
    %52 = llvm.add %51, %4 overflow<nsw, nuw> : i64
    %53 = llvm.getelementptr inbounds|nuw %49[%52] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %0, %53 : f64, !llvm.ptr
    %54 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %55 = llvm.mlir.constant(4 : index) : i64
    %56 = llvm.mul %4, %55 overflow<nsw, nuw> : i64
    %57 = llvm.add %56, %3 overflow<nsw, nuw> : i64
    %58 = llvm.getelementptr inbounds|nuw %54[%57] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %58 : f64, !llvm.ptr
    %59 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %60 = llvm.mlir.constant(4 : index) : i64
    %61 = llvm.mul %4, %60 overflow<nsw, nuw> : i64
    %62 = llvm.add %61, %2 overflow<nsw, nuw> : i64
    %63 = llvm.getelementptr inbounds|nuw %59[%62] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %63 : f64, !llvm.ptr
    %64 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %65 = llvm.mlir.constant(4 : index) : i64
    %66 = llvm.mul %3, %65 overflow<nsw, nuw> : i64
    %67 = llvm.add %66, %5 overflow<nsw, nuw> : i64
    %68 = llvm.getelementptr inbounds|nuw %64[%67] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %68 : f64, !llvm.ptr
    %69 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %70 = llvm.mlir.constant(4 : index) : i64
    %71 = llvm.mul %3, %70 overflow<nsw, nuw> : i64
    %72 = llvm.add %71, %4 overflow<nsw, nuw> : i64
    %73 = llvm.getelementptr inbounds|nuw %69[%72] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %73 : f64, !llvm.ptr
    %74 = llvm.fmul %arg1, %arg1 : f64
    %75 = llvm.fadd %74, %6 : f64
    %76 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %77 = llvm.mlir.constant(4 : index) : i64
    %78 = llvm.mul %3, %77 overflow<nsw, nuw> : i64
    %79 = llvm.add %78, %3 overflow<nsw, nuw> : i64
    %80 = llvm.getelementptr inbounds|nuw %76[%79] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %75, %80 : f64, !llvm.ptr
    %81 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %82 = llvm.mlir.constant(4 : index) : i64
    %83 = llvm.mul %3, %82 overflow<nsw, nuw> : i64
    %84 = llvm.add %83, %2 overflow<nsw, nuw> : i64
    %85 = llvm.getelementptr inbounds|nuw %81[%84] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %85 : f64, !llvm.ptr
    %86 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %87 = llvm.mlir.constant(4 : index) : i64
    %88 = llvm.mul %2, %87 overflow<nsw, nuw> : i64
    %89 = llvm.add %88, %5 overflow<nsw, nuw> : i64
    %90 = llvm.getelementptr inbounds|nuw %86[%89] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %90 : f64, !llvm.ptr
    %91 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %92 = llvm.mlir.constant(4 : index) : i64
    %93 = llvm.mul %2, %92 overflow<nsw, nuw> : i64
    %94 = llvm.add %93, %4 overflow<nsw, nuw> : i64
    %95 = llvm.getelementptr inbounds|nuw %91[%94] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %95 : f64, !llvm.ptr
    %96 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %97 = llvm.mlir.constant(4 : index) : i64
    %98 = llvm.mul %2, %97 overflow<nsw, nuw> : i64
    %99 = llvm.add %98, %3 overflow<nsw, nuw> : i64
    %100 = llvm.getelementptr inbounds|nuw %96[%99] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %100 : f64, !llvm.ptr
    %101 = llvm.fmul %arg1, %arg1 : f64
    %102 = llvm.intr.sin(%arg2) : (f64) -> f64
    %103 = llvm.intr.sin(%arg2) : (f64) -> f64
    %104 = llvm.fmul %102, %103 : f64
    %105 = llvm.fmul %101, %104 : f64
    %106 = llvm.fadd %105, %6 : f64
    %107 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %108 = llvm.mlir.constant(4 : index) : i64
    %109 = llvm.mul %2, %108 overflow<nsw, nuw> : i64
    %110 = llvm.add %109, %2 overflow<nsw, nuw> : i64
    %111 = llvm.getelementptr inbounds|nuw %107[%110] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %106, %111 : f64, !llvm.ptr
    llvm.return %23 : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
  }
}

