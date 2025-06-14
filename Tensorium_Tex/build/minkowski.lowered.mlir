module {
  llvm.func @minkowski(%arg0: f64, %arg1: f64, %arg2: f64, %arg3: f64, %arg4: f64, %arg5: f64, %arg6: f64, %arg7: f64, %arg8: f64, %arg9: f64, %arg10: f64, %arg11: f64, %arg12: f64, %arg13: f64, %arg14: f64, %arg15: f64) -> f64 {
    %0 = llvm.fmul %arg1, %arg1  : f64
    %1 = llvm.fmul %arg13, %arg13  : f64
    %2 = llvm.mlir.constant(-1.000000e+00 : f64) : f64
    %3 = llvm.fmul %arg12, %arg12  : f64
    %4 = llvm.fmul %3, %2  : f64
    %5 = llvm.fmul %arg14, %arg14  : f64
    %6 = llvm.fmul %0, %5  : f64
    %7 = llvm.fmul %arg15, %arg15  : f64
    %8 = llvm.fmul %arg3, %7  : f64
    %9 = llvm.intr.sin(%8)  : (f64) -> f64
    %10 = llvm.fmul %9, %9  : f64
    %11 = llvm.fmul %0, %10  : f64
    %12 = llvm.fadd %1, %4  : f64
    %13 = llvm.fadd %12, %6  : f64
    %14 = llvm.fadd %13, %11  : f64
    %15 = llvm.fadd %14, %14  : f64
    llvm.return %15 : f64
  }
}

