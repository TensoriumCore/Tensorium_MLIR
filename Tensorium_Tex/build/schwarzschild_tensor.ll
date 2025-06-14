; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

declare ptr @malloc(i64)

define { ptr, ptr, i64, [2 x i64], [2 x i64] } @schwarzschild_tensor(double %0, double %1, double %2, double %3) {
  %5 = call ptr @malloc(i64 128)
  %6 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %5, 0
  %7 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %6, ptr %5, 1
  %8 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %7, i64 0, 2
  %9 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %8, i64 4, 3, 0
  %10 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %9, i64 4, 3, 1
  %11 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %10, i64 4, 4, 0
  %12 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %11, i64 1, 4, 1
  %13 = fdiv double 1.000000e+00, %1
  %14 = fmul double %1, -1.000000e+00
  %15 = fadd double %14, 0.000000e+00
  %16 = fmul double %13, %15
  %17 = fadd double %16, 0.000000e+00
  %18 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %19 = getelementptr inbounds nuw double, ptr %18, i64 0
  store double %17, ptr %19, align 8
  %20 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %21 = getelementptr inbounds nuw double, ptr %20, i64 1
  store double 0.000000e+00, ptr %21, align 8
  %22 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %23 = getelementptr inbounds nuw double, ptr %22, i64 2
  store double 0.000000e+00, ptr %23, align 8
  %24 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %25 = getelementptr inbounds nuw double, ptr %24, i64 3
  store double 0.000000e+00, ptr %25, align 8
  %26 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %27 = getelementptr inbounds nuw double, ptr %26, i64 4
  store double 0.000000e+00, ptr %27, align 8
  %28 = fdiv double 1.000000e+00, %1
  %29 = fmul double %1, %28
  %30 = fadd double %29, 0.000000e+00
  %31 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %32 = getelementptr inbounds nuw double, ptr %31, i64 5
  store double %30, ptr %32, align 8
  %33 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %34 = getelementptr inbounds nuw double, ptr %33, i64 6
  store double 0.000000e+00, ptr %34, align 8
  %35 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %36 = getelementptr inbounds nuw double, ptr %35, i64 7
  store double 0.000000e+00, ptr %36, align 8
  %37 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %38 = getelementptr inbounds nuw double, ptr %37, i64 8
  store double 0.000000e+00, ptr %38, align 8
  %39 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %40 = getelementptr inbounds nuw double, ptr %39, i64 9
  store double 0.000000e+00, ptr %40, align 8
  %41 = fmul double %1, %1
  %42 = fadd double %41, 0.000000e+00
  %43 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %44 = getelementptr inbounds nuw double, ptr %43, i64 10
  store double %42, ptr %44, align 8
  %45 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %46 = getelementptr inbounds nuw double, ptr %45, i64 11
  store double 0.000000e+00, ptr %46, align 8
  %47 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %48 = getelementptr inbounds nuw double, ptr %47, i64 12
  store double 0.000000e+00, ptr %48, align 8
  %49 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %50 = getelementptr inbounds nuw double, ptr %49, i64 13
  store double 0.000000e+00, ptr %50, align 8
  %51 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %52 = getelementptr inbounds nuw double, ptr %51, i64 14
  store double 0.000000e+00, ptr %52, align 8
  %53 = fmul double %1, %1
  %54 = call double @llvm.sin.f64(double %2)
  %55 = call double @llvm.sin.f64(double %2)
  %56 = fmul double %54, %55
  %57 = fmul double %53, %56
  %58 = fadd double %57, 0.000000e+00
  %59 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %60 = getelementptr inbounds nuw double, ptr %59, i64 15
  store double %58, ptr %60, align 8
  ret { ptr, ptr, i64, [2 x i64], [2 x i64] } %12
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.sin.f64(double) #0

attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
