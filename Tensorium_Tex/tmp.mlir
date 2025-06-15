module {
  llvm.func @free(!llvm.ptr)
  llvm.func @malloc(i64) -> !llvm.ptr
  llvm.func @metric_generator(!llvm.ptr, !llvm.ptr, i64, i64, i64, !llvm.ptr, !llvm.ptr, i64, i64, i64, i64, i64) attributes {sym_visibility = "private"}
  llvm.func @christoffel_numeric(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: f64, %arg6: !llvm.ptr, %arg7: !llvm.ptr, %arg8: i64, %arg9: i64, %arg10: i64, %arg11: i64, %arg12: i64, %arg13: !llvm.ptr, %arg14: !llvm.ptr, %arg15: i64, %arg16: i64, %arg17: i64, %arg18: i64, %arg19: i64, %arg20: !llvm.ptr, %arg21: !llvm.ptr, %arg22: i64, %arg23: i64, %arg24: i64, %arg25: i64, %arg26: i64, %arg27: i64, %arg28: i64) {
    %0 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)>
    %1 = llvm.insertvalue %arg20, %0[0] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %2 = llvm.insertvalue %arg21, %1[1] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %3 = llvm.insertvalue %arg22, %2[2] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %4 = llvm.insertvalue %arg23, %3[3, 0] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %5 = llvm.insertvalue %arg26, %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %6 = llvm.insertvalue %arg24, %5[3, 1] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %7 = llvm.insertvalue %arg27, %6[4, 1] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %8 = llvm.insertvalue %arg25, %7[3, 2] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %9 = llvm.insertvalue %arg28, %8[4, 2] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %10 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %11 = llvm.insertvalue %arg13, %10[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %12 = llvm.insertvalue %arg14, %11[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %13 = llvm.insertvalue %arg15, %12[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %14 = llvm.insertvalue %arg16, %13[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %15 = llvm.insertvalue %arg18, %14[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %16 = llvm.insertvalue %arg17, %15[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %17 = llvm.insertvalue %arg19, %16[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %18 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %19 = llvm.insertvalue %arg0, %18[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %20 = llvm.insertvalue %arg1, %19[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %21 = llvm.insertvalue %arg2, %20[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %22 = llvm.insertvalue %arg3, %21[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %23 = llvm.insertvalue %arg4, %22[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %24 = llvm.mlir.constant(5.000000e-01 : f64) : f64
    %25 = llvm.mlir.constant(0.000000e+00 : f64) : f64
    %26 = llvm.mlir.constant(2.000000e+00 : f64) : f64
    %27 = llvm.mlir.constant(0 : index) : i64
    %28 = llvm.mlir.constant(1 : index) : i64
    %29 = llvm.mlir.constant(4 : index) : i64
    %30 = llvm.mlir.constant(4 : index) : i64
    %31 = llvm.mlir.constant(4 : index) : i64
    %32 = llvm.mlir.constant(4 : index) : i64
    %33 = llvm.mlir.constant(1 : index) : i64
    %34 = llvm.mlir.constant(16 : index) : i64
    %35 = llvm.mlir.constant(64 : index) : i64
    %36 = llvm.mlir.zero : !llvm.ptr
    %37 = llvm.getelementptr %36[%35] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %38 = llvm.ptrtoint %37 : !llvm.ptr to i64
    %39 = llvm.call @malloc(%38) : (i64) -> !llvm.ptr
    %40 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)>
    %41 = llvm.insertvalue %39, %40[0] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %42 = llvm.insertvalue %39, %41[1] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %43 = llvm.mlir.constant(0 : index) : i64
    %44 = llvm.insertvalue %43, %42[2] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %45 = llvm.insertvalue %30, %44[3, 0] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %46 = llvm.insertvalue %31, %45[3, 1] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %47 = llvm.insertvalue %32, %46[3, 2] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %48 = llvm.insertvalue %34, %47[4, 0] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %49 = llvm.insertvalue %32, %48[4, 1] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %50 = llvm.insertvalue %33, %49[4, 2] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %51 = llvm.mlir.constant(4 : index) : i64
    %52 = llvm.mlir.constant(4 : index) : i64
    %53 = llvm.mlir.constant(4 : index) : i64
    %54 = llvm.mlir.constant(1 : index) : i64
    %55 = llvm.mlir.constant(16 : index) : i64
    %56 = llvm.mlir.constant(64 : index) : i64
    %57 = llvm.mlir.zero : !llvm.ptr
    %58 = llvm.getelementptr %57[%56] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %59 = llvm.ptrtoint %58 : !llvm.ptr to i64
    %60 = llvm.call @malloc(%59) : (i64) -> !llvm.ptr
    %61 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)>
    %62 = llvm.insertvalue %60, %61[0] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %63 = llvm.insertvalue %60, %62[1] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %64 = llvm.mlir.constant(0 : index) : i64
    %65 = llvm.insertvalue %64, %63[2] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %66 = llvm.insertvalue %51, %65[3, 0] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %67 = llvm.insertvalue %52, %66[3, 1] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %68 = llvm.insertvalue %53, %67[3, 2] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %69 = llvm.insertvalue %55, %68[4, 0] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %70 = llvm.insertvalue %53, %69[4, 1] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %71 = llvm.insertvalue %54, %70[4, 2] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    llvm.br ^bb1(%27 : i64)
  ^bb1(%72: i64):  // 2 preds: ^bb0, ^bb8
    %73 = llvm.icmp "slt" %72, %29 : i64
    llvm.cond_br %73, ^bb2, ^bb9
  ^bb2:  // pred: ^bb1
    %74 = llvm.mlir.constant(4 : index) : i64
    %75 = llvm.mlir.constant(1 : index) : i64
    %76 = llvm.mlir.zero : !llvm.ptr
    %77 = llvm.getelementptr %76[%74] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %78 = llvm.ptrtoint %77 : !llvm.ptr to i64
    %79 = llvm.call @malloc(%78) : (i64) -> !llvm.ptr
    %80 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %81 = llvm.insertvalue %79, %80[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %82 = llvm.insertvalue %79, %81[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %83 = llvm.mlir.constant(0 : index) : i64
    %84 = llvm.insertvalue %83, %82[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %85 = llvm.insertvalue %74, %84[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %86 = llvm.insertvalue %75, %85[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %87 = llvm.mlir.constant(4 : index) : i64
    %88 = llvm.mlir.constant(1 : index) : i64
    %89 = llvm.mlir.zero : !llvm.ptr
    %90 = llvm.getelementptr %89[%87] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %91 = llvm.ptrtoint %90 : !llvm.ptr to i64
    %92 = llvm.call @malloc(%91) : (i64) -> !llvm.ptr
    %93 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %94 = llvm.insertvalue %92, %93[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %95 = llvm.insertvalue %92, %94[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %96 = llvm.mlir.constant(0 : index) : i64
    %97 = llvm.insertvalue %96, %95[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %98 = llvm.insertvalue %87, %97[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %99 = llvm.insertvalue %88, %98[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %100 = llvm.mlir.constant(1 : index) : i64
    %101 = llvm.extractvalue %23[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %102 = llvm.mul %100, %101 : i64
    %103 = llvm.mlir.zero : !llvm.ptr
    %104 = llvm.getelementptr %103[1] : (!llvm.ptr) -> !llvm.ptr, f64
    %105 = llvm.ptrtoint %104 : !llvm.ptr to i64
    %106 = llvm.mul %102, %105 : i64
    %107 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %108 = llvm.extractvalue %23[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %109 = llvm.getelementptr %107[%108] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %110 = llvm.extractvalue %86[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %111 = llvm.extractvalue %86[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %112 = llvm.getelementptr %110[%111] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    "llvm.intr.memcpy"(%112, %109, %106) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %113 = llvm.mlir.constant(1 : index) : i64
    %114 = llvm.extractvalue %23[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %115 = llvm.mul %113, %114 : i64
    %116 = llvm.mlir.zero : !llvm.ptr
    %117 = llvm.getelementptr %116[1] : (!llvm.ptr) -> !llvm.ptr, f64
    %118 = llvm.ptrtoint %117 : !llvm.ptr to i64
    %119 = llvm.mul %115, %118 : i64
    %120 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %121 = llvm.extractvalue %23[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %122 = llvm.getelementptr %120[%121] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %123 = llvm.extractvalue %99[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %124 = llvm.extractvalue %99[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %125 = llvm.getelementptr %123[%124] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    "llvm.intr.memcpy"(%125, %122, %119) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %126 = llvm.extractvalue %86[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %127 = llvm.getelementptr inbounds|nuw %126[%72] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %128 = llvm.load %127 : !llvm.ptr -> f64
    %129 = llvm.fadd %128, %arg5 : f64
    %130 = llvm.extractvalue %86[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %131 = llvm.getelementptr inbounds|nuw %130[%72] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %129, %131 : f64, !llvm.ptr
    %132 = llvm.extractvalue %99[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %133 = llvm.getelementptr inbounds|nuw %132[%72] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %134 = llvm.load %133 : !llvm.ptr -> f64
    %135 = llvm.fsub %134, %arg5 : f64
    %136 = llvm.extractvalue %99[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %137 = llvm.getelementptr inbounds|nuw %136[%72] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %135, %137 : f64, !llvm.ptr
    %138 = llvm.mlir.constant(4 : index) : i64
    %139 = llvm.mlir.constant(4 : index) : i64
    %140 = llvm.mlir.constant(1 : index) : i64
    %141 = llvm.mlir.constant(16 : index) : i64
    %142 = llvm.mlir.zero : !llvm.ptr
    %143 = llvm.getelementptr %142[%141] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %144 = llvm.ptrtoint %143 : !llvm.ptr to i64
    %145 = llvm.call @malloc(%144) : (i64) -> !llvm.ptr
    %146 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %147 = llvm.insertvalue %145, %146[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %148 = llvm.insertvalue %145, %147[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %149 = llvm.mlir.constant(0 : index) : i64
    %150 = llvm.insertvalue %149, %148[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %151 = llvm.insertvalue %138, %150[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %152 = llvm.insertvalue %139, %151[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %153 = llvm.insertvalue %139, %152[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %154 = llvm.insertvalue %140, %153[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %155 = llvm.mlir.constant(4 : index) : i64
    %156 = llvm.mlir.constant(4 : index) : i64
    %157 = llvm.mlir.constant(1 : index) : i64
    %158 = llvm.mlir.constant(16 : index) : i64
    %159 = llvm.mlir.zero : !llvm.ptr
    %160 = llvm.getelementptr %159[%158] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %161 = llvm.ptrtoint %160 : !llvm.ptr to i64
    %162 = llvm.call @malloc(%161) : (i64) -> !llvm.ptr
    %163 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %164 = llvm.insertvalue %162, %163[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %165 = llvm.insertvalue %162, %164[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %166 = llvm.mlir.constant(0 : index) : i64
    %167 = llvm.insertvalue %166, %165[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %168 = llvm.insertvalue %155, %167[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %169 = llvm.insertvalue %156, %168[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %170 = llvm.insertvalue %156, %169[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %171 = llvm.insertvalue %157, %170[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %172 = llvm.extractvalue %86[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %173 = llvm.extractvalue %86[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %174 = llvm.extractvalue %86[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %175 = llvm.extractvalue %86[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %176 = llvm.extractvalue %86[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %177 = llvm.extractvalue %154[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %178 = llvm.extractvalue %154[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %179 = llvm.extractvalue %154[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %180 = llvm.extractvalue %154[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %181 = llvm.extractvalue %154[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %182 = llvm.extractvalue %154[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %183 = llvm.extractvalue %154[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @metric_generator(%172, %173, %174, %175, %176, %177, %178, %179, %180, %181, %182, %183) : (!llvm.ptr, !llvm.ptr, i64, i64, i64, !llvm.ptr, !llvm.ptr, i64, i64, i64, i64, i64) -> ()
    %184 = llvm.extractvalue %99[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %185 = llvm.extractvalue %99[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %186 = llvm.extractvalue %99[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %187 = llvm.extractvalue %99[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %188 = llvm.extractvalue %99[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %189 = llvm.extractvalue %171[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %190 = llvm.extractvalue %171[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %191 = llvm.extractvalue %171[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %192 = llvm.extractvalue %171[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %193 = llvm.extractvalue %171[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %194 = llvm.extractvalue %171[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %195 = llvm.extractvalue %171[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @metric_generator(%184, %185, %186, %187, %188, %189, %190, %191, %192, %193, %194, %195) : (!llvm.ptr, !llvm.ptr, i64, i64, i64, !llvm.ptr, !llvm.ptr, i64, i64, i64, i64, i64) -> ()
    llvm.br ^bb3(%27 : i64)
  ^bb3(%196: i64):  // 2 preds: ^bb2, ^bb7
    %197 = llvm.icmp "slt" %196, %29 : i64
    llvm.cond_br %197, ^bb4, ^bb8
  ^bb4:  // pred: ^bb3
    llvm.br ^bb5(%27 : i64)
  ^bb5(%198: i64):  // 2 preds: ^bb4, ^bb6
    %199 = llvm.icmp "slt" %198, %29 : i64
    llvm.cond_br %199, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %200 = llvm.extractvalue %154[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %201 = llvm.mlir.constant(4 : index) : i64
    %202 = llvm.mul %196, %201 overflow<nsw, nuw> : i64
    %203 = llvm.add %202, %198 overflow<nsw, nuw> : i64
    %204 = llvm.getelementptr inbounds|nuw %200[%203] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %205 = llvm.load %204 : !llvm.ptr -> f64
    %206 = llvm.extractvalue %171[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %207 = llvm.mlir.constant(4 : index) : i64
    %208 = llvm.mul %196, %207 overflow<nsw, nuw> : i64
    %209 = llvm.add %208, %198 overflow<nsw, nuw> : i64
    %210 = llvm.getelementptr inbounds|nuw %206[%209] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %211 = llvm.load %210 : !llvm.ptr -> f64
    %212 = llvm.fsub %205, %211 : f64
    %213 = llvm.fmul %arg5, %26 : f64
    %214 = llvm.fdiv %212, %213 : f64
    %215 = llvm.extractvalue %50[1] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %216 = llvm.mlir.constant(16 : index) : i64
    %217 = llvm.mul %196, %216 overflow<nsw, nuw> : i64
    %218 = llvm.mlir.constant(4 : index) : i64
    %219 = llvm.mul %198, %218 overflow<nsw, nuw> : i64
    %220 = llvm.add %217, %219 overflow<nsw, nuw> : i64
    %221 = llvm.add %220, %72 overflow<nsw, nuw> : i64
    %222 = llvm.getelementptr inbounds|nuw %215[%221] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %214, %222 : f64, !llvm.ptr
    %223 = llvm.add %198, %28 : i64
    llvm.br ^bb5(%223 : i64)
  ^bb7:  // pred: ^bb5
    %224 = llvm.add %196, %28 : i64
    llvm.br ^bb3(%224 : i64)
  ^bb8:  // pred: ^bb3
    %225 = llvm.extractvalue %154[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @free(%225) : (!llvm.ptr) -> ()
    %226 = llvm.extractvalue %171[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @free(%226) : (!llvm.ptr) -> ()
    %227 = llvm.extractvalue %86[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    llvm.call @free(%227) : (!llvm.ptr) -> ()
    %228 = llvm.extractvalue %99[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    llvm.call @free(%228) : (!llvm.ptr) -> ()
    %229 = llvm.add %72, %28 : i64
    llvm.br ^bb1(%229 : i64)
  ^bb9:  // pred: ^bb1
    llvm.br ^bb10(%27 : i64)
  ^bb10(%230: i64):  // 2 preds: ^bb9, ^bb17
    %231 = llvm.icmp "slt" %230, %29 : i64
    llvm.cond_br %231, ^bb11, ^bb18
  ^bb11:  // pred: ^bb10
    llvm.br ^bb12(%27 : i64)
  ^bb12(%232: i64):  // 2 preds: ^bb11, ^bb16
    %233 = llvm.icmp "slt" %232, %29 : i64
    llvm.cond_br %233, ^bb13, ^bb17
  ^bb13:  // pred: ^bb12
    llvm.br ^bb14(%27 : i64)
  ^bb14(%234: i64):  // 2 preds: ^bb13, ^bb15
    %235 = llvm.icmp "slt" %234, %29 : i64
    llvm.cond_br %235, ^bb15, ^bb16
  ^bb15:  // pred: ^bb14
    %236 = llvm.extractvalue %50[1] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %237 = llvm.mlir.constant(16 : index) : i64
    %238 = llvm.mul %232, %237 overflow<nsw, nuw> : i64
    %239 = llvm.mlir.constant(4 : index) : i64
    %240 = llvm.mul %230, %239 overflow<nsw, nuw> : i64
    %241 = llvm.add %238, %240 overflow<nsw, nuw> : i64
    %242 = llvm.add %241, %234 overflow<nsw, nuw> : i64
    %243 = llvm.getelementptr inbounds|nuw %236[%242] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %244 = llvm.load %243 : !llvm.ptr -> f64
    %245 = llvm.extractvalue %50[1] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %246 = llvm.mlir.constant(16 : index) : i64
    %247 = llvm.mul %234, %246 overflow<nsw, nuw> : i64
    %248 = llvm.mlir.constant(4 : index) : i64
    %249 = llvm.mul %230, %248 overflow<nsw, nuw> : i64
    %250 = llvm.add %247, %249 overflow<nsw, nuw> : i64
    %251 = llvm.add %250, %232 overflow<nsw, nuw> : i64
    %252 = llvm.getelementptr inbounds|nuw %245[%251] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %253 = llvm.load %252 : !llvm.ptr -> f64
    %254 = llvm.extractvalue %50[1] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %255 = llvm.mlir.constant(16 : index) : i64
    %256 = llvm.mul %234, %255 overflow<nsw, nuw> : i64
    %257 = llvm.mlir.constant(4 : index) : i64
    %258 = llvm.mul %232, %257 overflow<nsw, nuw> : i64
    %259 = llvm.add %256, %258 overflow<nsw, nuw> : i64
    %260 = llvm.add %259, %230 overflow<nsw, nuw> : i64
    %261 = llvm.getelementptr inbounds|nuw %254[%260] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %262 = llvm.load %261 : !llvm.ptr -> f64
    %263 = llvm.fadd %244, %253 : f64
    %264 = llvm.fsub %263, %262 : f64
    %265 = llvm.fmul %264, %24 : f64
    %266 = llvm.extractvalue %71[1] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %267 = llvm.mlir.constant(16 : index) : i64
    %268 = llvm.mul %230, %267 overflow<nsw, nuw> : i64
    %269 = llvm.mlir.constant(4 : index) : i64
    %270 = llvm.mul %232, %269 overflow<nsw, nuw> : i64
    %271 = llvm.add %268, %270 overflow<nsw, nuw> : i64
    %272 = llvm.add %271, %234 overflow<nsw, nuw> : i64
    %273 = llvm.getelementptr inbounds|nuw %266[%272] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %265, %273 : f64, !llvm.ptr
    %274 = llvm.add %234, %28 : i64
    llvm.br ^bb14(%274 : i64)
  ^bb16:  // pred: ^bb14
    %275 = llvm.add %232, %28 : i64
    llvm.br ^bb12(%275 : i64)
  ^bb17:  // pred: ^bb12
    %276 = llvm.add %230, %28 : i64
    llvm.br ^bb10(%276 : i64)
  ^bb18:  // pred: ^bb10
    llvm.br ^bb19(%27 : i64)
  ^bb19(%277: i64):  // 2 preds: ^bb18, ^bb29
    %278 = llvm.icmp "slt" %277, %29 : i64
    llvm.cond_br %278, ^bb20, ^bb30
  ^bb20:  // pred: ^bb19
    llvm.br ^bb21(%27 : i64)
  ^bb21(%279: i64):  // 2 preds: ^bb20, ^bb28
    %280 = llvm.icmp "slt" %279, %29 : i64
    llvm.cond_br %280, ^bb22, ^bb29
  ^bb22:  // pred: ^bb21
    llvm.br ^bb23(%27 : i64)
  ^bb23(%281: i64):  // 2 preds: ^bb22, ^bb27
    %282 = llvm.icmp "slt" %281, %29 : i64
    llvm.cond_br %282, ^bb24, ^bb28
  ^bb24:  // pred: ^bb23
    llvm.br ^bb25(%27, %25 : i64, f64)
  ^bb25(%283: i64, %284: f64):  // 2 preds: ^bb24, ^bb26
    %285 = llvm.icmp "slt" %283, %29 : i64
    llvm.cond_br %285, ^bb26, ^bb27
  ^bb26:  // pred: ^bb25
    %286 = llvm.extractvalue %17[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %287 = llvm.mlir.constant(4 : index) : i64
    %288 = llvm.mul %277, %287 overflow<nsw, nuw> : i64
    %289 = llvm.add %288, %283 overflow<nsw, nuw> : i64
    %290 = llvm.getelementptr inbounds|nuw %286[%289] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %291 = llvm.load %290 : !llvm.ptr -> f64
    %292 = llvm.extractvalue %71[1] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %293 = llvm.mlir.constant(16 : index) : i64
    %294 = llvm.mul %283, %293 overflow<nsw, nuw> : i64
    %295 = llvm.mlir.constant(4 : index) : i64
    %296 = llvm.mul %279, %295 overflow<nsw, nuw> : i64
    %297 = llvm.add %294, %296 overflow<nsw, nuw> : i64
    %298 = llvm.add %297, %281 overflow<nsw, nuw> : i64
    %299 = llvm.getelementptr inbounds|nuw %292[%298] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %300 = llvm.load %299 : !llvm.ptr -> f64
    %301 = llvm.fmul %291, %300 : f64
    %302 = llvm.fadd %284, %301 : f64
    %303 = llvm.add %283, %28 : i64
    llvm.br ^bb25(%303, %302 : i64, f64)
  ^bb27:  // pred: ^bb25
    %304 = llvm.extractvalue %9[1] : !llvm.struct<(ptr, ptr, i64, array<3 x i64>, array<3 x i64>)> 
    %305 = llvm.mlir.constant(16 : index) : i64
    %306 = llvm.mul %277, %305 overflow<nsw, nuw> : i64
    %307 = llvm.mlir.constant(4 : index) : i64
    %308 = llvm.mul %279, %307 overflow<nsw, nuw> : i64
    %309 = llvm.add %306, %308 overflow<nsw, nuw> : i64
    %310 = llvm.add %309, %281 overflow<nsw, nuw> : i64
    %311 = llvm.getelementptr inbounds|nuw %304[%310] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %284, %311 : f64, !llvm.ptr
    %312 = llvm.add %281, %28 : i64
    llvm.br ^bb23(%312 : i64)
  ^bb28:  // pred: ^bb23
    %313 = llvm.add %279, %28 : i64
    llvm.br ^bb21(%313 : i64)
  ^bb29:  // pred: ^bb21
    %314 = llvm.add %277, %28 : i64
    llvm.br ^bb19(%314 : i64)
  ^bb30:  // pred: ^bb19
    llvm.return
  }
}

