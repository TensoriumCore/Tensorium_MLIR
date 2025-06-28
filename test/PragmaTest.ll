; ModuleID = 'PragmaTest.rewritten.cpp'
source_filename = "PragmaTest.rewritten.cpp"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx15.0.0"

@global = global i32 0, align 4
@.str = private unnamed_addr constant [14 x i8] c"tensorium_gpu\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [25 x i8] c"PragmaTest.rewritten.cpp\00", section "llvm.metadata"
@llvm.global.annotations = appending global [11 x { ptr, ptr, ptr, i32, ptr }] [{ ptr, ptr, ptr, i32, ptr } { ptr @_Z3foov, ptr @.str, ptr @.str.1, i32 5, ptr null }, { ptr, ptr, ptr, i32, ptr } { ptr @_Z3barv, ptr @.str, ptr @.str.1, i32 7, ptr null }, { ptr, ptr, ptr, i32, ptr } { ptr @_Z3bazi, ptr @.str, ptr @.str.1, i32 9, ptr null }, { ptr, ptr, ptr, i32, ptr } { ptr @_Z3quxdi, ptr @.str, ptr @.str.1, i32 11, ptr null }, { ptr, ptr, ptr, i32, ptr } { ptr @_Z10overloadedv, ptr @.str, ptr @.str.1, i32 21, ptr null }, { ptr, ptr, ptr, i32, ptr } { ptr @_Z10overloadedi, ptr @.str, ptr @.str.1, i32 22, ptr null }, { ptr, ptr, ptr, i32, ptr } { ptr @_Z10overloadedd, ptr @.str, ptr @.str.1, i32 23, ptr null }, { ptr, ptr, ptr, i32, ptr } { ptr @_Z10proto_funcv, ptr @.str, ptr @.str.1, i32 26, ptr null }, { ptr, ptr, ptr, i32, ptr } { ptr @_Z14compute_energyddi, ptr @.str, ptr @.str.1, i32 28, ptr null }, { ptr, ptr, ptr, i32, ptr } { ptr @_ZL10staticfuncv, ptr @.str, ptr @.str.1, i32 13, ptr null }, { ptr, ptr, ptr, i32, ptr } { ptr @_Z10inlinefuncv, ptr @.str, ptr @.str.1, i32 15, ptr null }], section "llvm.metadata"

; Function Attrs: mustprogress noinline nounwind optnone ssp uwtable
define void @_Z3foov() #0 {
  ret void
}

; Function Attrs: mustprogress noinline nounwind optnone ssp uwtable
define void @_Z3barv() #0 {
  ret void
}

; Function Attrs: mustprogress noinline nounwind optnone ssp uwtable
define void @_Z3bazi(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  ret void
}

; Function Attrs: mustprogress noinline nounwind optnone ssp uwtable
define void @_Z3quxdi(double noundef %0, i32 noundef %1) #0 {
  %3 = alloca double, align 8
  %4 = alloca i32, align 4
  store double %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  ret void
}

; Function Attrs: mustprogress noinline nounwind optnone ssp uwtable
define void @_Z10overloadedv() #0 {
  ret void
}

; Function Attrs: mustprogress noinline nounwind optnone ssp uwtable
define void @_Z10overloadedi(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  ret void
}

; Function Attrs: mustprogress noinline nounwind optnone ssp uwtable
define void @_Z10overloadedd(double noundef %0) #0 {
  %2 = alloca double, align 8
  store double %0, ptr %2, align 8
  ret void
}

; Function Attrs: mustprogress noinline nounwind optnone ssp uwtable
define void @_Z10proto_funcv() #0 {
  ret void
}

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
  store double 1.000000e+00, ptr %7, align 8
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
  %22 = fmul double 5.000000e-01, %21
  %23 = load double, ptr %7, align 8
  %24 = fmul double %22, %23
  ret double %24
}

; Function Attrs: mustprogress noinline norecurse optnone ssp uwtable
define noundef i32 @main() #1 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @_Z3foov()
  call void @_Z3barv()
  call void @_Z3bazi(i32 noundef 123)
  call void @_ZL10staticfuncv()
  call void @_Z10inlinefuncv()
  call void @_Z10overloadedv()
  call void @_Z10overloadedi(i32 noundef 42)
  call void @_Z10overloadedd(double noundef 3.140000e+00)
  call void @_Z10proto_funcv()
  call void @_Z3quxdi(double noundef 1.230000e+00, i32 noundef 4)
  store i32 123, ptr @global, align 4
  %2 = call noundef double @_Z14compute_energyddi(double noundef 1.200000e+00, double noundef 3.400000e+00, i32 noundef 2)
  ret i32 0
}

; Function Attrs: mustprogress noinline nounwind optnone ssp uwtable
define internal void @_ZL10staticfuncv() #0 {
  ret void
}

; Function Attrs: mustprogress noinline nounwind optnone ssp uwtable
define linkonce_odr void @_Z10inlinefuncv() #0 {
  ret void
}

attributes #0 = { mustprogress noinline nounwind optnone ssp uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress noinline norecurse optnone ssp uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"uwtable", i32 2}
!3 = !{i32 7, !"frame-pointer", i32 2}
!4 = !{!"clang version 21.0.0git (https://github.com/llvm/llvm-project.git 3c02150f02022292645f6238524f0401a6f5014f)"}
!5 = distinct !{!5, !6}
!6 = !{!"llvm.loop.mustprogress"}
