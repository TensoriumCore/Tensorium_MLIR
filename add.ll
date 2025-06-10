; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define double @add(double %0, double %1) {
  %3 = fadd double %0, %1
  ret double %3
}

define double @sub(double %0, double %1) {
  %3 = fsub double %0, %1
  ret double %3
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
