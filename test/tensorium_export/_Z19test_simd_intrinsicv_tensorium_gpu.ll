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
  store float 0xR800000, ptr %5, align 4
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
  store float 0xR800000, ptr %7, align 4
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
