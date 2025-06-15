; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

declare ptr @malloc(i64)

define { ptr, ptr, i64, [2 x i64], [2 x i64] } @minkowski_tensor(double %0, double %1, double %2, double %3, double %4, double %5) {
  %7 = call ptr @malloc(i64 128)
  %8 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %7, 0
  %9 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %8, ptr %7, 1
  %10 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %9, i64 0, 2
  %11 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %10, i64 4, 3, 0
  %12 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %11, i64 4, 3, 1
  %13 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, i64 4, 4, 0
  %14 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %13, i64 1, 4, 1
  %15 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %16 = getelementptr inbounds nuw double, ptr %15, i64 0
  store double -1.000000e+00, ptr %16, align 8
  %17 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %18 = getelementptr inbounds nuw double, ptr %17, i64 1
  store double 0.000000e+00, ptr %18, align 8
  %19 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %20 = getelementptr inbounds nuw double, ptr %19, i64 2
  store double 0.000000e+00, ptr %20, align 8
  %21 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %22 = getelementptr inbounds nuw double, ptr %21, i64 3
  store double 0.000000e+00, ptr %22, align 8
  %23 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %24 = getelementptr inbounds nuw double, ptr %23, i64 4
  store double 0.000000e+00, ptr %24, align 8
  %25 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %26 = getelementptr inbounds nuw double, ptr %25, i64 5
  store double 1.000000e+00, ptr %26, align 8
  %27 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %28 = getelementptr inbounds nuw double, ptr %27, i64 6
  store double 0.000000e+00, ptr %28, align 8
  %29 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %30 = getelementptr inbounds nuw double, ptr %29, i64 7
  store double 0.000000e+00, ptr %30, align 8
  %31 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %32 = getelementptr inbounds nuw double, ptr %31, i64 8
  store double 0.000000e+00, ptr %32, align 8
  %33 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %34 = getelementptr inbounds nuw double, ptr %33, i64 9
  store double 0.000000e+00, ptr %34, align 8
  %35 = fmul double %1, %1
  %36 = fadd double %35, 0.000000e+00
  %37 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %38 = getelementptr inbounds nuw double, ptr %37, i64 10
  store double %36, ptr %38, align 8
  %39 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %40 = getelementptr inbounds nuw double, ptr %39, i64 11
  store double 0.000000e+00, ptr %40, align 8
  %41 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %42 = getelementptr inbounds nuw double, ptr %41, i64 12
  store double 0.000000e+00, ptr %42, align 8
  %43 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %44 = getelementptr inbounds nuw double, ptr %43, i64 13
  store double 0.000000e+00, ptr %44, align 8
  %45 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %46 = getelementptr inbounds nuw double, ptr %45, i64 14
  store double 0.000000e+00, ptr %46, align 8
  %47 = fmul double %1, %1
  %48 = call double @llvm.sin.f64(double %2)
  %49 = call double @llvm.sin.f64(double %2)
  %50 = fmul double %48, %49
  %51 = fmul double %47, %50
  %52 = fadd double %51, 0.000000e+00
  %53 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, 1
  %54 = getelementptr inbounds nuw double, ptr %53, i64 15
  store double %52, ptr %54, align 8
  ret { ptr, ptr, i64, [2 x i64], [2 x i64] } %14
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.sin.f64(double) #0

attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
