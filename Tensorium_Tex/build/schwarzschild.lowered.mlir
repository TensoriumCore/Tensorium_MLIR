module {
  llvm.func @schwarzschild(%arg0: f64, %arg1: f64, %arg2: f64, %arg3: f64) -> f64 {
    %0 = llvm.mlir.constant(0.000000e+00 : f64) : f64
    %1 = llvm.mlir.constant(-1.000000e+00 : f64) : f64
    %2 = llvm.mlir.constant(-2.000000e+00 : f64) : f64
    %3 = llvm.mlir.constant(1.000000e+00 : f64) : f64
    %4 = llvm.mlir.constant(4.000000e+00 : f64) : f64
    %5 = llvm.fdiv %3, %arg1 : f64
    %6 = llvm.fadd %arg1, %2 : f64
    %7 = llvm.fdiv %3, %6 : f64
    %8 = llvm.fadd %arg1, %1 : f64
    %9 = llvm.fmul %5, %4 : f64
    %10 = llvm.fmul %9, %7 : f64
    %11 = llvm.fmul %10, %8 : f64
    %12 = llvm.fadd %11, %0 : f64
    llvm.return %12 : f64
  }
}

