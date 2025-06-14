module {
  llvm.func @kerr_schild_simple(%arg0: f64, %arg1: f64, %arg2: f64, %arg3: f64, %arg4: f64, %arg5: f64, %arg6: f64, %arg7: f64, %arg8: f64, %arg9: f64, %arg10: f64, %arg11: f64, %arg12: f64, %arg13: f64, %arg14: f64, %arg15: f64) -> f64 {
    %0 = llvm.fmul %arg5, %arg5  : f64
    %1 = llvm.fmul %arg1, %arg1  : f64
    %2 = llvm.fadd %0, %1  : f64
    %3 = llvm.fmul %2, %2  : f64
    %4 = llvm.fmul %arg1, %arg1  : f64
    %5 = llvm.fmul %4, %arg1  : f64
    %6 = llvm.fmul %5, %arg1  : f64
    %7 = llvm.fmul %arg8, %arg8  : f64
    %8 = llvm.fmul %0, %7  : f64
    %9 = llvm.fadd %6, %8  : f64
    %10 = llvm.mlir.constant(1.000000e+00 : f64) : f64
    %11 = llvm.fdiv %10, %3  : f64
    %12 = llvm.mlir.constant(1.000000e+00 : f64) : f64
    %13 = llvm.fdiv %12, %9  : f64
    %14 = llvm.fmul %arg9, %arg9  : f64
    %15 = llvm.fmul %arg10, %arg10  : f64
    %16 = llvm.fmul %arg11, %arg11  : f64
    %17 = llvm.mlir.constant(-1.000000e+00 : f64) : f64
    %18 = llvm.fmul %arg12, %arg12  : f64
    %19 = llvm.fmul %18, %17  : f64
    %20 = llvm.fadd %14, %15  : f64
    %21 = llvm.fadd %20, %16  : f64
    %22 = llvm.fadd %21, %19  : f64
    %23 = llvm.fmul %3, %9  : f64
    %24 = llvm.fmul %23, %22  : f64
    %25 = llvm.mlir.constant(2.000000e+00 : f64) : f64
    %26 = llvm.fmul %arg5, %arg7  : f64
    %27 = llvm.fmul %arg1, %arg6  : f64
    %28 = llvm.fadd %26, %27  : f64
    %29 = llvm.fmul %arg9, %28  : f64
    %30 = llvm.mlir.constant(-1.000000e+00 : f64) : f64
    %31 = llvm.fmul %arg5, %arg6  : f64
    %32 = llvm.mlir.constant(-1.000000e+00 : f64) : f64
    %33 = llvm.fmul %arg1, %32  : f64
    %34 = llvm.fmul %33, %arg7  : f64
    %35 = llvm.fadd %31, %34  : f64
    %36 = llvm.fmul %arg10, %30  : f64
    %37 = llvm.fmul %36, %35  : f64
    %38 = llvm.fadd %29, %37  : f64
    %39 = llvm.fmul %arg1, %38  : f64
    %40 = llvm.fmul %arg12, %arg1  : f64
    %41 = llvm.fmul %40, %2  : f64
    %42 = llvm.fmul %arg11, %2  : f64
    %43 = llvm.fmul %42, %arg8  : f64
    %44 = llvm.fadd %39, %41  : f64
    %45 = llvm.fadd %44, %43  : f64
    %46 = llvm.fmul %45, %45  : f64
    %47 = llvm.fmul %arg0, %25  : f64
    %48 = llvm.fmul %47, %arg1  : f64
    %49 = llvm.fmul %48, %46  : f64
    %50 = llvm.fadd %24, %49  : f64
    %51 = llvm.fmul %11, %13  : f64
    %52 = llvm.fmul %51, %50  : f64
    %53 = llvm.fadd %52, %52  : f64
    llvm.return %53 : f64
  }
}

