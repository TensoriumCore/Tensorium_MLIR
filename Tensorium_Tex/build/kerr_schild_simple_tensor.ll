; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

declare ptr @malloc(i64)

define { ptr, ptr, i64, [2 x i64], [2 x i64] } @kerr_schild_simple_tensor(double %0, double %1, double %2, double %3) {
  %5 = call ptr @malloc(i64 128)
  %6 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %5, 0
  %7 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %6, ptr %5, 1
  %8 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %7, i64 0, 2
  %9 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %8, i64 4, 3, 0
  %10 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %9, i64 4, 3, 1
  %11 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %10, i64 4, 4, 0
  %12 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %11, i64 1, 4, 1
  %13 = fmul double %1, %1
  %14 = fmul double %13, %1
  %15 = fmul double %14, 0.000000e+00
  %16 = fmul double %15, 0x7FF0000000000000
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
  %28 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %29 = getelementptr inbounds nuw double, ptr %28, i64 5
  store double 0.000000e+00, ptr %29, align 8
  %30 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %31 = getelementptr inbounds nuw double, ptr %30, i64 6
  store double 0.000000e+00, ptr %31, align 8
  %32 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %33 = getelementptr inbounds nuw double, ptr %32, i64 7
  store double 0.000000e+00, ptr %33, align 8
  %34 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %35 = getelementptr inbounds nuw double, ptr %34, i64 8
  store double 0.000000e+00, ptr %35, align 8
  %36 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %37 = getelementptr inbounds nuw double, ptr %36, i64 9
  store double 0.000000e+00, ptr %37, align 8
  %38 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %39 = getelementptr inbounds nuw double, ptr %38, i64 10
  store double 0.000000e+00, ptr %39, align 8
  %40 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %41 = getelementptr inbounds nuw double, ptr %40, i64 11
  store double 0.000000e+00, ptr %41, align 8
  %42 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %43 = getelementptr inbounds nuw double, ptr %42, i64 12
  store double 0.000000e+00, ptr %43, align 8
  %44 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %45 = getelementptr inbounds nuw double, ptr %44, i64 13
  store double 0.000000e+00, ptr %45, align 8
  %46 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %47 = getelementptr inbounds nuw double, ptr %46, i64 14
  store double 0.000000e+00, ptr %47, align 8
  %48 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %49 = getelementptr inbounds nuw double, ptr %48, i64 15
  store double 0.000000e+00, ptr %49, align 8
  ret { ptr, ptr, i64, [2 x i64], [2 x i64] } %12
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
