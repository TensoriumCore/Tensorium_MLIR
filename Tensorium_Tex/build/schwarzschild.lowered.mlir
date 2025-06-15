module {
  llvm.func @schwarzschild(%arg0: f64, %arg1: f64, %arg2: f64, %arg3: f64, %arg4: f64, %arg5: f64) -> f64 {
    %0 = llvm.mlir.constant(0.000000e+00 : f64) : f64
    %1 = llvm.mlir.constant(-1.000000e+00 : f64) : f64
    %2 = llvm.mlir.constant(-2.000000e+00 : f64) : f64
    %3 = llvm.mlir.constant(4.000000e+00 : f64) : f64
    %4 = llvm.mlir.constant(1.000000e+00 : f64) : f64
    %5 = llvm.fdiv %4, %arg1 : f64
    %6 = llvm.fmul %arg4, %2 : f64
    %7 = llvm.fadd %arg1, %6 : f64
    %8 = llvm.fdiv %4, %7 : f64
    %9 = llvm.fmul %arg4, %1 : f64
    %10 = llvm.fadd %arg1, %9 : f64
    %11 = llvm.fmul %arg4, %3 : f64
    %12 = llvm.fmul %11, %5 : f64
    %13 = llvm.fmul %12, %8 : f64
    %14 = llvm.fmul %13, %10 : f64
    %15 = llvm.fadd %14, %0 : f64
    llvm.return %15 : f64
  }
}

