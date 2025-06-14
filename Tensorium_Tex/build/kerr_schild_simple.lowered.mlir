module {
  llvm.func @kerr_schild_simple(%arg0: f64, %arg1: f64, %arg2: f64, %arg3: f64) -> f64 {
    %0 = llvm.mlir.constant(0.000000e+00 : f64) : f64
    %1 = llvm.mlir.constant(2.000000e+00 : f64) : f64
    %2 = llvm.mlir.constant(1.000000e+00 : f64) : f64
    %3 = llvm.mlir.constant(8.000000e-01 : f64) : f64
    %4 = llvm.mlir.constant(2.500000e+00 : f64) : f64
    %5 = llvm.fmul %arg1, %1 : f64
    %6 = llvm.fadd %5, %2 : f64
    %7 = llvm.fadd %6, %2 : f64
    %8 = llvm.fmul %7, %7 : f64
    %9 = llvm.fmul %arg1, %1 : f64
    %10 = llvm.fmul %9, %8 : f64
    %11 = llvm.fadd %10, %4 : f64
    %12 = llvm.fmul %11, %3 : f64
    %13 = llvm.fadd %12, %0 : f64
    llvm.return %13 : f64
  }
}

