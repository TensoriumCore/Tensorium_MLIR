; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define double @kerr_schild_simple(double %0, double %1, double %2, double %3, double %4, double %5) {
  %7 = fmul double %5, -1.000000e+00
  %8 = fadd double %5, %1
  %9 = fadd double %8, %1
  %10 = fadd double %9, %7
  %11 = fmul double %1, %10
  %12 = fadd double %1, %11
  %13 = fadd double %12, 1.000000e+00
  %14 = fmul double %13, %13
  %15 = fmul double %4, %1
  %16 = fmul double %15, %14
  %17 = fadd double %16, 1.000000e+00
  %18 = fmul double %17, 2.000000e+00
  %19 = fadd double %18, 0.000000e+00
  ret double %19
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
