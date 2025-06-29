; Function Attrs: mustprogress noinline nounwind optnone ssp uwtable
define noundef double @_Z14compute_energyddi(double noundef %0, double noundef %1, i32 noundef %2) #0 {
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  %6 = alloca i32, align 4
  %7 = alloca double, align 8
  %8 = alloca i32, align 4
  store double %0, ptr %4, align 8
  store double %1, ptr %5, align 8
  store i32 %2, ptr %6, align 4
  store double 0xR10000000000000, ptr %7, align 8
  store i32 0, ptr %8, align 4
  br label %9

9:                                                ; preds = %17, %3
  %10 = load i32, ptr %8, align 4
  %11 = load i32, ptr %6, align 4
  %12 = icmp slt i32 %10, %11
  br i1 %12, label %13, label %20

13:                                               ; preds = %9
  %14 = load double, ptr %5, align 8
  %15 = load double, ptr %7, align 8
  %16 = fmul double %15, %14
  store double %16, ptr %7, align 8
  br label %17

17:                                               ; preds = %13
  %18 = load i32, ptr %8, align 4
  %19 = add nsw i32 %18, 1
  store i32 %19, ptr %8, align 4
  br label %9, !llvm.loop !5

20:                                               ; preds = %9
  %21 = load double, ptr %4, align 8
  %22 = fmul double 0xR10000000000000, %21
  %23 = load double, ptr %7, align 8
  %24 = fmul double %22, %23
  ret double %24
}
