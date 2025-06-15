; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define double @schwarzschild(double %0, double %1, double %2, double %3, double %4, double %5) {
  %7 = fdiv double 1.000000e+00, %1
  %8 = fmul double %4, -2.000000e+00
  %9 = fadd double %1, %8
  %10 = fdiv double 1.000000e+00, %9
  %11 = fmul double %4, -1.000000e+00
  %12 = fadd double %1, %11
  %13 = fmul double %4, 4.000000e+00
  %14 = fmul double %13, %7
  %15 = fmul double %14, %10
  %16 = fmul double %15, %12
  %17 = fadd double %16, 0.000000e+00
  ret double %17
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
