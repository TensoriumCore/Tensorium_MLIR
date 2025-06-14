module {
  llvm.func @flrw_flat(%arg0: f64, %arg1: f64, %arg2: f64, %arg3: f64, %arg4: f64, %arg5: f64, %arg6: f64, %arg7: f64, %arg8: f64, %arg9: f64, %arg10: f64, %arg11: f64, %arg12: f64, %arg13: f64, %arg14: f64, %arg15: f64) -> f64 {
    %0 = llvm.fmul %arg1, %arg1  : f64
    %1 = llvm.mlir.constant(-1.000000e+00 : f64) : f64
    %2 = llvm.fmul %arg12, %arg12  : f64
    %3 = llvm.fmul %2, %1  : f64
    %4 = llvm.fmul %arg5, %arg5  : f64
    %5 = llvm.fmul %arg13, %arg13  : f64
    %6 = llvm.fmul %arg14, %arg14  : f64
    %7 = llvm.fmul %0, %6  : f64
    %8 = llvm.fmul %arg15, %arg15  : f64
    %9 = llvm.fmul %arg3, %8  : f64
    %10 = llvm.intr.sin(%9)  : (f64) -> f64
    %11 = llvm.fmul %10, %10  : f64
    %12 = llvm.fmul %0, %11  : f64
    %13 = llvm.fadd %5, %7  : f64
    %14 = llvm.fadd %13, %12  : f64
    %15 = llvm.fmul %4, %14  : f64
    %16 = llvm.fadd %3, %15  : f64
    %17 = llvm.fadd %16, %16  : f64
    llvm.return %17 : f64
  }
}

