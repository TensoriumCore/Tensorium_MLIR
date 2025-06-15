module {
  llvm.func @kerr_schild_simple(%arg0: f64, %arg1: f64, %arg2: f64, %arg3: f64, %arg4: f64, %arg5: f64) -> f64 {
    %0 = llvm.mlir.constant(2.000000e+00 : f64) : f64
    %1 = llvm.mlir.constant(0.000000e+00 : f64) : f64
    %2 = llvm.mlir.constant(-1.000000e+00 : f64) : f64
    %3 = llvm.mlir.constant(1.000000e+00 : f64) : f64
    %4 = llvm.fmul %arg5, %2 : f64
    %5 = llvm.fadd %arg5, %arg1 : f64
    %6 = llvm.fadd %5, %arg1 : f64
    %7 = llvm.fadd %6, %4 : f64
    %8 = llvm.fmul %arg1, %7 : f64
    %9 = llvm.fadd %arg1, %8 : f64
    %10 = llvm.fadd %9, %3 : f64
    %11 = llvm.fmul %10, %10 : f64
    %12 = llvm.fmul %arg4, %arg1 : f64
    %13 = llvm.fmul %12, %11 : f64
    %14 = llvm.fadd %13, %3 : f64
    %15 = llvm.fmul %14, %0 : f64
    %16 = llvm.fadd %15, %1 : f64
    llvm.return %16 : f64
  }
}

