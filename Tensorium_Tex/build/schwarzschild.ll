; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define double @schwarzschild(double %0, double %1, double %2, double %3) {
  %5 = fdiv double 1.000000e+00, %1
  %6 = fadd double %1, -2.000000e+00
  %7 = fdiv double 1.000000e+00, %6
  %8 = fadd double %1, -1.000000e+00
  %9 = fmul double %5, 4.000000e+00
  %10 = fmul double %9, %7
  %11 = fmul double %10, %8
  %12 = fadd double %11, 0.000000e+00
  ret double %12
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
