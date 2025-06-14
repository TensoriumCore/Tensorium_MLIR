module {
  llvm.func @schwarzschild(%arg0: f64, %arg1: f64, %arg2: f64, %arg3: f64, %arg4: f64, %arg5: f64, %arg6: f64, %arg7: f64, %arg8: f64, %arg9: f64, %arg10: f64, %arg11: f64, %arg12: f64, %arg13: f64, %arg14: f64, %arg15: f64) -> f64 {
    %0 = llvm.mlir.constant(-1.000000e+00 : f64) : f64
    %1 = llvm.fmul %arg1, %0  : f64
    %2 = llvm.mlir.constant(2.000000e+00 : f64) : f64
    %3 = llvm.fmul %arg0, %2  : f64
    %4 = llvm.fadd %1, %3  : f64
    %5 = llvm.mlir.constant(1.000000e+00 : f64) : f64
    %6 = llvm.fdiv %5, %arg1  : f64
    %7 = llvm.mlir.constant(1.000000e+00 : f64) : f64
    %8 = llvm.fdiv %7, %4  : f64
    %9 = llvm.fmul %arg12, %arg12  : f64
    %10 = llvm.fmul %4, %4  : f64
    %11 = llvm.fmul %9, %10  : f64
    %12 = llvm.mlir.constant(-1.000000e+00 : f64) : f64
    %13 = llvm.fmul %arg13, %arg13  : f64
    %14 = llvm.fmul %arg1, %arg1  : f64
    %15 = llvm.fmul %13, %12  : f64
    %16 = llvm.fmul %15, %14  : f64
    %17 = llvm.fmul %arg1, %arg1  : f64
    %18 = llvm.fmul %17, %arg1  : f64
    %19 = llvm.fmul %arg14, %arg14  : f64
    %20 = llvm.fmul %arg15, %arg15  : f64
    %21 = llvm.fmul %arg3, %20  : f64
    %22 = llvm.intr.sin(%21)  : (f64) -> f64
    %23 = llvm.fmul %22, %22  : f64
    %24 = llvm.fadd %19, %23  : f64
    %25 = llvm.fmul %4, %18  : f64
    %26 = llvm.fmul %25, %24  : f64
    %27 = llvm.fadd %11, %16  : f64
    %28 = llvm.fadd %27, %26  : f64
    %29 = llvm.fmul %6, %8  : f64
    %30 = llvm.fmul %29, %28  : f64
    %31 = llvm.fadd %30, %30  : f64
    llvm.return %31 : f64
  }
}

