; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define double @flrw_flat(double %0, double %1, double %2, double %3, double %4, double %5, double %6, double %7, double %8, double %9, double %10, double %11, double %12, double %13, double %14, double %15) {
  %17 = fmul double %1, %1
  %18 = fmul double %12, %12
  %19 = fmul double %18, -1.000000e+00
  %20 = fmul double %5, %5
  %21 = fmul double %13, %13
  %22 = fmul double %14, %14
  %23 = fmul double %17, %22
  %24 = fmul double %15, %15
  %25 = fmul double %3, %24
  %26 = call double @llvm.sin.f64(double %25)
  %27 = fmul double %26, %26
  %28 = fmul double %17, %27
  %29 = fadd double %21, %23
  %30 = fadd double %29, %28
  %31 = fmul double %20, %30
  %32 = fadd double %19, %31
  %33 = fadd double %32, %32
  ret double %33
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.sin.f64(double) #0

attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
