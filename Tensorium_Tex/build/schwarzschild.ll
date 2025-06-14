; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define double @schwarzschild(double %0, double %1, double %2, double %3, double %4, double %5, double %6, double %7, double %8, double %9, double %10, double %11, double %12, double %13, double %14, double %15) {
  %17 = fmul double %1, -1.000000e+00
  %18 = fmul double %0, 2.000000e+00
  %19 = fadd double %17, %18
  %20 = fdiv double 1.000000e+00, %1
  %21 = fdiv double 1.000000e+00, %19
  %22 = fmul double %12, %12
  %23 = fmul double %19, %19
  %24 = fmul double %22, %23
  %25 = fmul double %13, %13
  %26 = fmul double %1, %1
  %27 = fmul double %25, -1.000000e+00
  %28 = fmul double %27, %26
  %29 = fmul double %1, %1
  %30 = fmul double %29, %1
  %31 = fmul double %14, %14
  %32 = fmul double %15, %15
  %33 = fmul double %3, %32
  %34 = call double @llvm.sin.f64(double %33)
  %35 = fmul double %34, %34
  %36 = fadd double %31, %35
  %37 = fmul double %19, %30
  %38 = fmul double %37, %36
  %39 = fadd double %24, %28
  %40 = fadd double %39, %38
  %41 = fmul double %20, %21
  %42 = fmul double %41, %40
  %43 = fadd double %42, %42
  ret double %43
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.sin.f64(double) #0

attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
