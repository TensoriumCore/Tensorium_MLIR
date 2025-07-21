module {
  llvm.func @malloc(i64) -> !llvm.ptr
  llvm.func @metric_component_impl(f64, f64, f64, f64, f64, f64, f64) -> f64 attributes {sym_visibility = "private"}
  func.func @metric_tensor(%arg0: f64, %arg1: f64, %arg2: f64, %arg3: f64, %arg4: f64) -> tensor<4x4xf64> {
    %0 = llvm.mlir.constant(0.000000e+00 : f64) : f64
    %1 = llvm.mlir.constant(1.000000e+00 : f64) : f64
    %2 = llvm.mlir.constant(2.000000e+00 : f64) : f64
    %3 = llvm.intr.pow(%arg4, %2) : (f64, f64) -> f64
    %4 = llvm.intr.sin(%arg2) : (f64) -> f64
    %5 = llvm.fmul %3, %4 : f64
    %6 = llvm.intr.pow(%arg2, %2) : (f64, f64) -> f64
    %7 = llvm.fmul %5, %6 : f64
    %8 = llvm.fmul %arg0, %2 : f64
    %9 = llvm.fsub %1, %8 : f64
    %10 = llvm.fdiv %9, %arg4 : f64
    %11 = llvm.fmul %arg0, %2 : f64
    %12 = llvm.fsub %1, %11 : f64
    %13 = llvm.fdiv %12, %arg4 : f64
    %14 = llvm.fneg %13 : f64
    %15 = llvm.mlir.constant(4 : index) : i64
    %16 = llvm.mlir.constant(4 : index) : i64
    %17 = llvm.mlir.constant(1 : index) : i64
    %18 = llvm.mlir.constant(16 : index) : i64
    %19 = llvm.mlir.zero : !llvm.ptr
    %20 = llvm.getelementptr %19[%18] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %21 = llvm.ptrtoint %20 : !llvm.ptr to i64
    %22 = llvm.mlir.constant(64 : index) : i64
    %23 = llvm.add %21, %22 : i64
    %24 = llvm.call @malloc(%23) : (i64) -> !llvm.ptr
    %25 = llvm.ptrtoint %24 : !llvm.ptr to i64
    %26 = llvm.mlir.constant(1 : index) : i64
    %27 = llvm.sub %22, %26 : i64
    %28 = llvm.add %25, %27 : i64
    %29 = llvm.urem %28, %22 : i64
    %30 = llvm.sub %28, %29 : i64
    %31 = llvm.inttoptr %30 : i64 to !llvm.ptr
    %32 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %33 = llvm.insertvalue %24, %32[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %34 = llvm.insertvalue %31, %33[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %35 = llvm.mlir.constant(0 : index) : i64
    %36 = llvm.insertvalue %35, %34[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %37 = llvm.insertvalue %15, %36[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %38 = llvm.insertvalue %16, %37[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %39 = llvm.insertvalue %16, %38[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %40 = llvm.insertvalue %17, %39[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %41 = builtin.unrealized_conversion_cast %40 : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> to memref<4x4xf64>
    %42 = llvm.mlir.constant(0 : index) : i64
    %43 = llvm.mlir.constant(1 : index) : i64
    %44 = llvm.mlir.constant(2 : index) : i64
    %45 = llvm.mlir.constant(3 : index) : i64
    %46 = llvm.extractvalue %40[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %47 = llvm.mlir.constant(4 : index) : i64
    %48 = llvm.mul %42, %47 overflow<nsw, nuw> : i64
    %49 = llvm.add %48, %42 overflow<nsw, nuw> : i64
    %50 = llvm.getelementptr inbounds|nuw %46[%49] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %7, %50 : f64, !llvm.ptr
    %51 = llvm.extractvalue %40[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %52 = llvm.mlir.constant(4 : index) : i64
    %53 = llvm.mul %42, %52 overflow<nsw, nuw> : i64
    %54 = llvm.add %53, %43 overflow<nsw, nuw> : i64
    %55 = llvm.getelementptr inbounds|nuw %51[%54] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %0, %55 : f64, !llvm.ptr
    %56 = llvm.extractvalue %40[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %57 = llvm.mlir.constant(4 : index) : i64
    %58 = llvm.mul %42, %57 overflow<nsw, nuw> : i64
    %59 = llvm.add %58, %44 overflow<nsw, nuw> : i64
    %60 = llvm.getelementptr inbounds|nuw %56[%59] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %0, %60 : f64, !llvm.ptr
    %61 = llvm.extractvalue %40[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %62 = llvm.mlir.constant(4 : index) : i64
    %63 = llvm.mul %42, %62 overflow<nsw, nuw> : i64
    %64 = llvm.add %63, %45 overflow<nsw, nuw> : i64
    %65 = llvm.getelementptr inbounds|nuw %61[%64] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %0, %65 : f64, !llvm.ptr
    %66 = llvm.extractvalue %40[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %67 = llvm.mlir.constant(4 : index) : i64
    %68 = llvm.mul %43, %67 overflow<nsw, nuw> : i64
    %69 = llvm.add %68, %42 overflow<nsw, nuw> : i64
    %70 = llvm.getelementptr inbounds|nuw %66[%69] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %0, %70 : f64, !llvm.ptr
    %71 = llvm.extractvalue %40[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %72 = llvm.mlir.constant(4 : index) : i64
    %73 = llvm.mul %43, %72 overflow<nsw, nuw> : i64
    %74 = llvm.add %73, %43 overflow<nsw, nuw> : i64
    %75 = llvm.getelementptr inbounds|nuw %71[%74] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %10, %75 : f64, !llvm.ptr
    %76 = llvm.extractvalue %40[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %77 = llvm.mlir.constant(4 : index) : i64
    %78 = llvm.mul %43, %77 overflow<nsw, nuw> : i64
    %79 = llvm.add %78, %44 overflow<nsw, nuw> : i64
    %80 = llvm.getelementptr inbounds|nuw %76[%79] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %0, %80 : f64, !llvm.ptr
    %81 = llvm.extractvalue %40[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %82 = llvm.mlir.constant(4 : index) : i64
    %83 = llvm.mul %43, %82 overflow<nsw, nuw> : i64
    %84 = llvm.add %83, %45 overflow<nsw, nuw> : i64
    %85 = llvm.getelementptr inbounds|nuw %81[%84] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %0, %85 : f64, !llvm.ptr
    %86 = llvm.extractvalue %40[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %87 = llvm.mlir.constant(4 : index) : i64
    %88 = llvm.mul %44, %87 overflow<nsw, nuw> : i64
    %89 = llvm.add %88, %42 overflow<nsw, nuw> : i64
    %90 = llvm.getelementptr inbounds|nuw %86[%89] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %0, %90 : f64, !llvm.ptr
    %91 = llvm.extractvalue %40[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %92 = llvm.mlir.constant(4 : index) : i64
    %93 = llvm.mul %44, %92 overflow<nsw, nuw> : i64
    %94 = llvm.add %93, %43 overflow<nsw, nuw> : i64
    %95 = llvm.getelementptr inbounds|nuw %91[%94] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %0, %95 : f64, !llvm.ptr
    %96 = llvm.extractvalue %40[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %97 = llvm.mlir.constant(4 : index) : i64
    %98 = llvm.mul %44, %97 overflow<nsw, nuw> : i64
    %99 = llvm.add %98, %44 overflow<nsw, nuw> : i64
    %100 = llvm.getelementptr inbounds|nuw %96[%99] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %14, %100 : f64, !llvm.ptr
    %101 = llvm.extractvalue %40[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %102 = llvm.mlir.constant(4 : index) : i64
    %103 = llvm.mul %44, %102 overflow<nsw, nuw> : i64
    %104 = llvm.add %103, %45 overflow<nsw, nuw> : i64
    %105 = llvm.getelementptr inbounds|nuw %101[%104] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %0, %105 : f64, !llvm.ptr
    %106 = llvm.extractvalue %40[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %107 = llvm.mlir.constant(4 : index) : i64
    %108 = llvm.mul %45, %107 overflow<nsw, nuw> : i64
    %109 = llvm.add %108, %42 overflow<nsw, nuw> : i64
    %110 = llvm.getelementptr inbounds|nuw %106[%109] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %0, %110 : f64, !llvm.ptr
    %111 = llvm.extractvalue %40[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %112 = llvm.mlir.constant(4 : index) : i64
    %113 = llvm.mul %45, %112 overflow<nsw, nuw> : i64
    %114 = llvm.add %113, %43 overflow<nsw, nuw> : i64
    %115 = llvm.getelementptr inbounds|nuw %111[%114] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %0, %115 : f64, !llvm.ptr
    %116 = llvm.extractvalue %40[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %117 = llvm.mlir.constant(4 : index) : i64
    %118 = llvm.mul %45, %117 overflow<nsw, nuw> : i64
    %119 = llvm.add %118, %44 overflow<nsw, nuw> : i64
    %120 = llvm.getelementptr inbounds|nuw %116[%119] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %0, %120 : f64, !llvm.ptr
    %121 = llvm.extractvalue %40[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %122 = llvm.mlir.constant(4 : index) : i64
    %123 = llvm.mul %45, %122 overflow<nsw, nuw> : i64
    %124 = llvm.add %123, %45 overflow<nsw, nuw> : i64
    %125 = llvm.getelementptr inbounds|nuw %121[%124] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %0, %125 : f64, !llvm.ptr
    %126 = bufferization.to_tensor %41 : memref<4x4xf64> to tensor<4x4xf64>
    return %126 : tensor<4x4xf64>
  }
}

