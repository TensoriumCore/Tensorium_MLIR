; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

declare ptr @malloc(i64)

define { ptr, ptr, i64, [2 x i64], [2 x i64] } @SchwarzschildSpatial(double %0, double %1, double %2, double %3) {
  %5 = insertelement <4 x double> undef, double %0, i64 0
  %6 = insertelement <4 x double> %5, double %1, i64 1
  %7 = insertelement <4 x double> %6, double %2, i64 2
  %8 = insertelement <4 x double> %7, double %3, i64 3
  %9 = extractelement <4 x double> %8, i64 1
  %10 = extractelement <4 x double> %8, i64 2
  %11 = extractelement <4 x double> %8, i64 3
  %12 = fmul double %9, %9
  %13 = fmul double %10, %10
  %14 = fmul double %11, %11
  %15 = fadd double %12, %13
  %16 = fadd double %15, %14
  %17 = fcmp olt double %16, 1.000000e-30
  %18 = select i1 %17, double 1.000000e-30, double %16
  %19 = call double @llvm.sqrt.f64(double %18)
  %20 = fdiv double 1.000000e+00, %19
  %21 = fdiv double %9, %19
  %22 = fdiv double %10, %19
  %23 = fdiv double %11, %19
  %24 = fmul double %20, 2.000000e+00
  %25 = fadd double %24, -1.000000e+00
  %26 = fmul double %24, %21
  %27 = fmul double %24, %22
  %28 = fmul double %24, %23
  %29 = fmul double %21, %21
  %30 = fmul double %21, %22
  %31 = fmul double %21, %23
  %32 = fmul double %22, %22
  %33 = fmul double %22, %23
  %34 = fmul double %23, %23
  %35 = fmul double %24, %29
  %36 = fmul double %24, %30
  %37 = fmul double %24, %31
  %38 = fmul double %24, %32
  %39 = fmul double %24, %33
  %40 = fmul double %24, %34
  %41 = fadd double %35, 1.000000e+00
  %42 = fadd double %38, 1.000000e+00
  %43 = fadd double %40, 1.000000e+00
  %44 = call ptr @malloc(i64 add (i64 ptrtoint (ptr getelementptr (double, ptr null, i32 16) to i64), i64 64))
  %45 = ptrtoint ptr %44 to i64
  %46 = add i64 %45, 63
  %47 = urem i64 %46, 64
  %48 = sub i64 %46, %47
  %49 = inttoptr i64 %48 to ptr
  %50 = getelementptr double, ptr %49, i64 0
  store double %25, ptr %50, align 8
  %51 = getelementptr double, ptr %49, i64 1
  store double %26, ptr %51, align 8
  %52 = getelementptr double, ptr %49, i64 2
  store double %27, ptr %52, align 8
  %53 = getelementptr double, ptr %49, i64 3
  store double %28, ptr %53, align 8
  %54 = getelementptr double, ptr %49, i64 4
  store double %26, ptr %54, align 8
  %55 = getelementptr double, ptr %49, i64 5
  store double %41, ptr %55, align 8
  %56 = getelementptr double, ptr %49, i64 6
  store double %36, ptr %56, align 8
  %57 = getelementptr double, ptr %49, i64 7
  store double %37, ptr %57, align 8
  %58 = getelementptr double, ptr %49, i64 8
  store double %27, ptr %58, align 8
  %59 = getelementptr double, ptr %49, i64 9
  store double %36, ptr %59, align 8
  %60 = getelementptr double, ptr %49, i64 10
  store double %42, ptr %60, align 8
  %61 = getelementptr double, ptr %49, i64 11
  store double %39, ptr %61, align 8
  %62 = getelementptr double, ptr %49, i64 12
  store double %28, ptr %62, align 8
  %63 = getelementptr double, ptr %49, i64 13
  store double %37, ptr %63, align 8
  %64 = getelementptr double, ptr %49, i64 14
  store double %39, ptr %64, align 8
  %65 = getelementptr double, ptr %49, i64 15
  store double %43, ptr %65, align 8
  %66 = call ptr @malloc(i64 add (i64 ptrtoint (ptr getelementptr (double, ptr null, i32 9) to i64), i64 64))
  %67 = ptrtoint ptr %66 to i64
  %68 = add i64 %67, 63
  %69 = urem i64 %68, 64
  %70 = sub i64 %68, %69
  %71 = inttoptr i64 %70 to ptr
  %72 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } undef, ptr %66, 0
  %73 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %72, ptr %71, 1
  %74 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %73, i64 0, 2
  %75 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %74, i64 3, 3, 0
  %76 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %75, i64 3, 3, 1
  %77 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %76, i64 3, 4, 0
  %78 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %77, i64 1, 4, 1
  br label %79

79:                                               ; preds = %96, %4
  %80 = phi i64 [ %97, %96 ], [ 0, %4 ]
  %81 = icmp slt i64 %80, 3
  br i1 %81, label %82, label %98

82:                                               ; preds = %79
  br label %83

83:                                               ; preds = %86, %82
  %84 = phi i64 [ %95, %86 ], [ 0, %82 ]
  %85 = icmp slt i64 %84, 3
  br i1 %85, label %86, label %96

86:                                               ; preds = %83
  %87 = getelementptr double, ptr %49, i32 5
  %88 = mul i64 %80, 4
  %89 = add i64 %88, %84
  %90 = getelementptr double, ptr %87, i64 %89
  %91 = load double, ptr %90, align 8
  %92 = mul i64 %80, 3
  %93 = add i64 %92, %84
  %94 = getelementptr double, ptr %71, i64 %93
  store double %91, ptr %94, align 8
  %95 = add i64 %84, 1
  br label %83

96:                                               ; preds = %83
  %97 = add i64 %80, 1
  br label %79

98:                                               ; preds = %79
  ret { ptr, ptr, i64, [2 x i64], [2 x i64] } %78
}

define void @_mlir_ciface_SchwarzschildSpatial(ptr %0, double %1, double %2, double %3, double %4) {
  %6 = call { ptr, ptr, i64, [2 x i64], [2 x i64] } @SchwarzschildSpatial(double %1, double %2, double %3, double %4)
  store { ptr, ptr, i64, [2 x i64], [2 x i64] } %6, ptr %0, align 8
  ret void
}

define { double, { ptr, ptr, i64, [2 x i64], [2 x i64] } } @DetInvGamma(double %0, double %1, double %2, double %3) {
  %5 = call { ptr, ptr, i64, [2 x i64], [2 x i64] } @SchwarzschildSpatial(double %0, double %1, double %2, double %3)
  %6 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, 1
  %7 = getelementptr double, ptr %6, i64 0
  %8 = load double, ptr %7, align 8
  %9 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, 1
  %10 = getelementptr double, ptr %9, i64 1
  %11 = load double, ptr %10, align 8
  %12 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, 1
  %13 = getelementptr double, ptr %12, i64 2
  %14 = load double, ptr %13, align 8
  %15 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, 1
  %16 = getelementptr double, ptr %15, i64 3
  %17 = load double, ptr %16, align 8
  %18 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, 1
  %19 = getelementptr double, ptr %18, i64 4
  %20 = load double, ptr %19, align 8
  %21 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, 1
  %22 = getelementptr double, ptr %21, i64 5
  %23 = load double, ptr %22, align 8
  %24 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, 1
  %25 = getelementptr double, ptr %24, i64 6
  %26 = load double, ptr %25, align 8
  %27 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, 1
  %28 = getelementptr double, ptr %27, i64 7
  %29 = load double, ptr %28, align 8
  %30 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, 1
  %31 = getelementptr double, ptr %30, i64 8
  %32 = load double, ptr %31, align 8
  %33 = fmul double %20, %32
  %34 = fmul double %23, %29
  %35 = fsub double %33, %34
  %36 = fmul double %17, %32
  %37 = fmul double %23, %26
  %38 = fsub double %36, %37
  %39 = fneg double %38
  %40 = fmul double %17, %29
  %41 = fmul double %20, %26
  %42 = fsub double %40, %41
  %43 = fmul double %8, %35
  %44 = fmul double %11, %39
  %45 = fadd double %43, %44
  %46 = fmul double %14, %42
  %47 = fadd double %45, %46
  %48 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, 1
  %49 = getelementptr double, ptr %48, i64 0
  %50 = load double, ptr %49, align 8
  %51 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, 1
  %52 = getelementptr double, ptr %51, i64 1
  %53 = load double, ptr %52, align 8
  %54 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, 1
  %55 = getelementptr double, ptr %54, i64 2
  %56 = load double, ptr %55, align 8
  %57 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, 1
  %58 = getelementptr double, ptr %57, i64 3
  %59 = load double, ptr %58, align 8
  %60 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, 1
  %61 = getelementptr double, ptr %60, i64 4
  %62 = load double, ptr %61, align 8
  %63 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, 1
  %64 = getelementptr double, ptr %63, i64 5
  %65 = load double, ptr %64, align 8
  %66 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, 1
  %67 = getelementptr double, ptr %66, i64 6
  %68 = load double, ptr %67, align 8
  %69 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, 1
  %70 = getelementptr double, ptr %69, i64 7
  %71 = load double, ptr %70, align 8
  %72 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, 1
  %73 = getelementptr double, ptr %72, i64 8
  %74 = load double, ptr %73, align 8
  %75 = fmul double %62, %74
  %76 = fmul double %65, %71
  %77 = fsub double %75, %76
  %78 = fmul double %59, %74
  %79 = fmul double %65, %68
  %80 = fsub double %78, %79
  %81 = fneg double %80
  %82 = fmul double %59, %71
  %83 = fmul double %62, %68
  %84 = fsub double %82, %83
  %85 = fmul double %53, %74
  %86 = fmul double %56, %71
  %87 = fsub double %85, %86
  %88 = fneg double %87
  %89 = fmul double %50, %74
  %90 = fmul double %56, %68
  %91 = fsub double %89, %90
  %92 = fmul double %50, %71
  %93 = fmul double %53, %68
  %94 = fsub double %92, %93
  %95 = fneg double %94
  %96 = fmul double %53, %65
  %97 = fmul double %56, %62
  %98 = fsub double %96, %97
  %99 = fmul double %50, %65
  %100 = fmul double %56, %59
  %101 = fsub double %99, %100
  %102 = fneg double %101
  %103 = fmul double %50, %62
  %104 = fmul double %53, %59
  %105 = fsub double %103, %104
  %106 = fmul double %50, %77
  %107 = fmul double %53, %81
  %108 = fadd double %106, %107
  %109 = fmul double %56, %84
  %110 = fadd double %108, %109
  %111 = fcmp olt double %110, 0.000000e+00
  %112 = fneg double %110
  %113 = select i1 %111, double %112, double %110
  %114 = fcmp oge double %113, 1.000000e-18
  %115 = select i1 %114, double %113, double 1.000000e-18
  %116 = fdiv double 1.000000e+00, %115
  %117 = fneg double %116
  %118 = select i1 %111, double %117, double %116
  %119 = call ptr @malloc(i64 add (i64 ptrtoint (ptr getelementptr (double, ptr null, i32 9) to i64), i64 64))
  %120 = ptrtoint ptr %119 to i64
  %121 = add i64 %120, 63
  %122 = urem i64 %121, 64
  %123 = sub i64 %121, %122
  %124 = inttoptr i64 %123 to ptr
  %125 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } undef, ptr %119, 0
  %126 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %125, ptr %124, 1
  %127 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %126, i64 0, 2
  %128 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %127, i64 3, 3, 0
  %129 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %128, i64 3, 3, 1
  %130 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %129, i64 3, 4, 0
  %131 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %130, i64 1, 4, 1
  %132 = fmul double %77, %118
  %133 = getelementptr double, ptr %124, i64 0
  store double %132, ptr %133, align 8
  %134 = fmul double %88, %118
  %135 = getelementptr double, ptr %124, i64 1
  store double %134, ptr %135, align 8
  %136 = fmul double %98, %118
  %137 = getelementptr double, ptr %124, i64 2
  store double %136, ptr %137, align 8
  %138 = fmul double %81, %118
  %139 = getelementptr double, ptr %124, i64 3
  store double %138, ptr %139, align 8
  %140 = fmul double %91, %118
  %141 = getelementptr double, ptr %124, i64 4
  store double %140, ptr %141, align 8
  %142 = fmul double %102, %118
  %143 = getelementptr double, ptr %124, i64 5
  store double %142, ptr %143, align 8
  %144 = fmul double %84, %118
  %145 = getelementptr double, ptr %124, i64 6
  store double %144, ptr %145, align 8
  %146 = fmul double %95, %118
  %147 = getelementptr double, ptr %124, i64 7
  store double %146, ptr %147, align 8
  %148 = fmul double %105, %118
  %149 = getelementptr double, ptr %124, i64 8
  store double %148, ptr %149, align 8
  %150 = insertvalue { double, { ptr, ptr, i64, [2 x i64], [2 x i64] } } undef, double %47, 0
  %151 = insertvalue { double, { ptr, ptr, i64, [2 x i64], [2 x i64] } } %150, { ptr, ptr, i64, [2 x i64], [2 x i64] } %131, 1
  ret { double, { ptr, ptr, i64, [2 x i64], [2 x i64] } } %151
}

define void @_mlir_ciface_DetInvGamma(ptr %0, double %1, double %2, double %3, double %4) {
  %6 = call { double, { ptr, ptr, i64, [2 x i64], [2 x i64] } } @DetInvGamma(double %1, double %2, double %3, double %4)
  store { double, { ptr, ptr, i64, [2 x i64], [2 x i64] } } %6, ptr %0, align 8
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.sqrt.f64(double) #0

attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
