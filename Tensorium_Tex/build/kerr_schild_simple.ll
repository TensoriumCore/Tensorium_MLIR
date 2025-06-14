; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define double @kerr_schild_simple(double %0, double %1, double %2, double %3) {
  %5 = fmul double %1, 2.000000e+00
  %6 = fadd double %5, 1.000000e+00
  %7 = fadd double %6, 1.000000e+00
  %8 = fmul double %7, %7
  %9 = fmul double %1, 2.000000e+00
  %10 = fmul double %9, %8
  %11 = fadd double %10, 2.500000e+00
  %12 = fmul double %11, 8.000000e-01
  %13 = fadd double %12, 0.000000e+00
  ret double %13
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
