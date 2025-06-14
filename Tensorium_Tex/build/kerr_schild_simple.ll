; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define double @kerr_schild_simple(double %0, double %1, double %2, double %3, double %4, double %5, double %6, double %7, double %8, double %9, double %10, double %11, double %12, double %13, double %14, double %15) {
  %17 = fmul double %5, %5
  %18 = fmul double %1, %1
  %19 = fadd double %17, %18
  %20 = fmul double %19, %19
  %21 = fmul double %1, %1
  %22 = fmul double %21, %1
  %23 = fmul double %22, %1
  %24 = fmul double %8, %8
  %25 = fmul double %17, %24
  %26 = fadd double %23, %25
  %27 = fdiv double 1.000000e+00, %20
  %28 = fdiv double 1.000000e+00, %26
  %29 = fmul double %9, %9
  %30 = fmul double %10, %10
  %31 = fmul double %11, %11
  %32 = fmul double %12, %12
  %33 = fmul double %32, -1.000000e+00
  %34 = fadd double %29, %30
  %35 = fadd double %34, %31
  %36 = fadd double %35, %33
  %37 = fmul double %20, %26
  %38 = fmul double %37, %36
  %39 = fmul double %5, %7
  %40 = fmul double %1, %6
  %41 = fadd double %39, %40
  %42 = fmul double %9, %41
  %43 = fmul double %5, %6
  %44 = fmul double %1, -1.000000e+00
  %45 = fmul double %44, %7
  %46 = fadd double %43, %45
  %47 = fmul double %10, -1.000000e+00
  %48 = fmul double %47, %46
  %49 = fadd double %42, %48
  %50 = fmul double %1, %49
  %51 = fmul double %12, %1
  %52 = fmul double %51, %19
  %53 = fmul double %11, %19
  %54 = fmul double %53, %8
  %55 = fadd double %50, %52
  %56 = fadd double %55, %54
  %57 = fmul double %56, %56
  %58 = fmul double %0, 2.000000e+00
  %59 = fmul double %58, %1
  %60 = fmul double %59, %57
  %61 = fadd double %38, %60
  %62 = fmul double %27, %28
  %63 = fmul double %62, %61
  %64 = fadd double %63, %63
  ret double %64
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
