; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define double @flrw_flat(double %0, double %1, double %2, double %3, double %4, double %5) {
  %7 = fmul double %5, %5
  %8 = fadd double %7, -1.000000e+00
  %9 = fadd double %8, 0.000000e+00
  ret double %9
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
