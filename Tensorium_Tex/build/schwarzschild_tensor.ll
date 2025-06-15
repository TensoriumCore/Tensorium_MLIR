; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

declare ptr @malloc(i64)

define { ptr, ptr, i64, [2 x i64], [2 x i64] } @schwarzschild_tensor(double %0, double %1, double %2, double %3, double %4, double %5) {
  %7 = call ptr @malloc(i64 128)
  %8 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %7, 0
  %9 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %8, ptr %7, 1
  %10 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %9, i64 0, 2
  %11 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %10, i64 4, 3, 0
  %12 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %11, i64 4, 3, 1
  %13 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, i64 4, 4, 0
  %14 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %13, i64 1, 4, 1
  %15 = fdiv double 1.000000e+00, %1
  %16 = fmul double %1, -1.000000e+00
  %17 = fmul double %4, 2.000000e+00
  %18 = fadd double %16, %17
  %19 = fmul double %15, %18
  %20 = fadd double %19, 0.000000e+00
  %21 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %22 = getelementptr inbounds nuw double, ptr %21, i64 0
  store double %20, ptr %22, align 8
  %23 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %24 = getelementptr inbounds nuw double, ptr %23, i64 1
  store double 0.000000e+00, ptr %24, align 8
  %25 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %26 = getelementptr inbounds nuw double, ptr %25, i64 2
  store double 0.000000e+00, ptr %26, align 8
  %27 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %28 = getelementptr inbounds nuw double, ptr %27, i64 3
  store double 0.000000e+00, ptr %28, align 8
  %29 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %30 = getelementptr inbounds nuw double, ptr %29, i64 4
  store double 0.000000e+00, ptr %30, align 8
  %31 = fmul double %4, -2.000000e+00
  %32 = fadd double %1, %31
  %33 = fdiv double 1.000000e+00, %32
  %34 = fmul double %1, %33
  %35 = fadd double %34, 0.000000e+00
  %36 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %37 = getelementptr inbounds nuw double, ptr %36, i64 5
  store double %35, ptr %37, align 8
  %38 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %39 = getelementptr inbounds nuw double, ptr %38, i64 6
  store double 0.000000e+00, ptr %39, align 8
  %40 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %41 = getelementptr inbounds nuw double, ptr %40, i64 7
  store double 0.000000e+00, ptr %41, align 8
  %42 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %43 = getelementptr inbounds nuw double, ptr %42, i64 8
  store double 0.000000e+00, ptr %43, align 8
  %44 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %45 = getelementptr inbounds nuw double, ptr %44, i64 9
  store double 0.000000e+00, ptr %45, align 8
  %46 = fmul double %1, %1
  %47 = fadd double %46, 0.000000e+00
  %48 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %49 = getelementptr inbounds nuw double, ptr %48, i64 10
  store double %47, ptr %49, align 8
  %50 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %51 = getelementptr inbounds nuw double, ptr %50, i64 11
  store double 0.000000e+00, ptr %51, align 8
  %52 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %53 = getelementptr inbounds nuw double, ptr %52, i64 12
  store double 0.000000e+00, ptr %53, align 8
  %54 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %55 = getelementptr inbounds nuw double, ptr %54, i64 13
  store double 0.000000e+00, ptr %55, align 8
  %56 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %57 = getelementptr inbounds nuw double, ptr %56, i64 14
  store double 0.000000e+00, ptr %57, align 8
  %58 = fmul double %1, %1
  %59 = call double @llvm.sin.f64(double %2)
  %60 = call double @llvm.sin.f64(double %2)
  %61 = fmul double %59, %60
  %62 = fmul double %58, %61
  %63 = fadd double %62, 0.000000e+00
  %64 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %65 = getelementptr inbounds nuw double, ptr %64, i64 15
  store double %63, ptr %65, align 8
  ret { ptr, ptr, i64, [2 x i64], [2 x i64] } %14
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.sin.f64(double) #0

attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
