; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define double @minkowski(double %0, double %1, double %2, double %3, double %4, double %5, double %6, double %7, double %8, double %9, double %10, double %11, double %12, double %13, double %14, double %15) {
  %17 = fmul double %1, %1
  %18 = fmul double %13, %13
  %19 = fmul double %12, %12
  %20 = fmul double %19, -1.000000e+00
  %21 = fmul double %14, %14
  %22 = fmul double %17, %21
  %23 = fmul double %15, %15
  %24 = fmul double %3, %23
  %25 = call double @llvm.sin.f64(double %24)
  %26 = fmul double %25, %25
  %27 = fmul double %17, %26
  %28 = fadd double %18, %20
  %29 = fadd double %28, %22
  %30 = fadd double %29, %27
  %31 = fadd double %30, %30
  ret double %31
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.sin.f64(double) #0

attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
