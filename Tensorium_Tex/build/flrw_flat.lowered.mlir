module {
  llvm.func @flrw_flat(%arg0: f64, %arg1: f64, %arg2: f64, %arg3: f64) -> f64 {
    %0 = llvm.mlir.constant(-7.500000e-01 : f64) : f64
    llvm.return %0 : f64
  }
}

