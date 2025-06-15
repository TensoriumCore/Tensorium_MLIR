module {
  llvm.func @flrw_flat(%arg0: f64, %arg1: f64, %arg2: f64, %arg3: f64, %arg4: f64, %arg5: f64) -> f64 {
    %0 = llvm.mlir.constant(0.000000e+00 : f64) : f64
    %1 = llvm.mlir.constant(-1.000000e+00 : f64) : f64
    %2 = llvm.fmul %arg5, %arg5 : f64
    %3 = llvm.fadd %2, %1 : f64
    %4 = llvm.fadd %3, %0 : f64
    llvm.return %4 : f64
  }
}

