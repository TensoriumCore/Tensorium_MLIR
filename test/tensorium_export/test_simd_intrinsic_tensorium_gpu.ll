; ModuleID = 'tensorium_export/test_simd_intrinsic_tensorium_gpu.cpp'
source_filename = "tensorium_export/test_simd_intrinsic_tensorium_gpu.cpp"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx15.0.0"

@.str = private unnamed_addr constant [14 x i8] c"tensorium_gpu\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [55 x i8] c"tensorium_export/test_simd_intrinsic_tensorium_gpu.cpp\00", section "llvm.metadata"
@llvm.global.annotations = appending global [1 x { ptr, ptr, ptr, i32, ptr }] [{ ptr, ptr, ptr, i32, ptr } { ptr @_Z19test_simd_intrinsicv, ptr @.str, ptr @.str.1, i32 3, ptr null }], section "llvm.metadata"

; Function Attrs: mustprogress noinline optnone ssp uwtable
define void @_Z19test_simd_intrinsicv() #0 {
  %1 = alloca ptr, align 8
  %2 = alloca <4 x float>, align 16
  %3 = alloca <4 x float>, align 16
  %4 = alloca <4 x float>, align 16
  %5 = alloca float, align 4
  %6 = alloca <4 x float>, align 16
  %7 = alloca float, align 4
  %8 = alloca <4 x float>, align 16
  %9 = alloca <4 x float>, align 16
  %10 = alloca <4 x float>, align 16
  %11 = alloca <4 x float>, align 16
  %12 = alloca [4 x float], align 16
  store float 1.000000e+00, ptr %5, align 4
  %13 = load float, ptr %5, align 4
  %14 = insertelement <4 x float> poison, float %13, i32 0
  %15 = load float, ptr %5, align 4
  %16 = insertelement <4 x float> %14, float %15, i32 1
  %17 = load float, ptr %5, align 4
  %18 = insertelement <4 x float> %16, float %17, i32 2
  %19 = load float, ptr %5, align 4
  %20 = insertelement <4 x float> %18, float %19, i32 3
  store <4 x float> %20, ptr %6, align 16
  %21 = load <4 x float>, ptr %6, align 16
  store <4 x float> %21, ptr %9, align 16
  store float 2.000000e+00, ptr %7, align 4
  %22 = load float, ptr %7, align 4
  %23 = insertelement <4 x float> poison, float %22, i32 0
  %24 = load float, ptr %7, align 4
  %25 = insertelement <4 x float> %23, float %24, i32 1
  %26 = load float, ptr %7, align 4
  %27 = insertelement <4 x float> %25, float %26, i32 2
  %28 = load float, ptr %7, align 4
  %29 = insertelement <4 x float> %27, float %28, i32 3
  store <4 x float> %29, ptr %8, align 16
  %30 = load <4 x float>, ptr %8, align 16
  store <4 x float> %30, ptr %10, align 16
  %31 = load <4 x float>, ptr %9, align 16
  %32 = load <4 x float>, ptr %10, align 16
  store <4 x float> %31, ptr %3, align 16
  store <4 x float> %32, ptr %4, align 16
  %33 = load <4 x float>, ptr %3, align 16
  %34 = load <4 x float>, ptr %4, align 16
  %35 = fadd <4 x float> %33, %34
  store <4 x float> %35, ptr %11, align 16
  %36 = getelementptr inbounds [4 x float], ptr %12, i64 0, i64 0
  %37 = load <4 x float>, ptr %11, align 16
  store ptr %36, ptr %1, align 8
  store <4 x float> %37, ptr %2, align 16
  %38 = load <4 x float>, ptr %2, align 16
  %39 = load ptr, ptr %1, align 8
  store <4 x float> %38, ptr %39, align 1
  ret void
}

attributes #0 = { mustprogress noinline optnone ssp uwtable "frame-pointer"="all" "min-legal-vector-width"="128" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"uwtable", i32 2}
!3 = !{i32 7, !"frame-pointer", i32 2}
!4 = !{!"clang version 21.0.0git (https://github.com/llvm/llvm-project.git 3c02150f02022292645f6238524f0401a6f5014f)"}
