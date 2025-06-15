module {
  func.func private @metric_generator(%x: memref<4xf64>, %g: memref<4x4xf64>) -> ()

  func.func @christoffel_numeric(%x: memref<4xf64>, %h: f64, %g0:   memref<4x4xf64>, %ginv: memref<4x4xf64>, %out:  memref<4x4x4xf64>) {
    %c0_f64 = arith.constant 0.0 : f64
    %c1_f64 = arith.constant 1.0 : f64
    %two = arith.constant 2.0 : f64
    %c0_idx = arith.constant 0 : index
    %c1_idx = arith.constant 1 : index
    %c_dim = arith.constant 4 : index
    %dg  = memref.alloc() : memref<4x4x4xf64>
    %tmp = memref.alloc() : memref<4x4x4xf64>
    scf.for %rho = %c0_idx to %c_dim step %c1_idx {
      %x_plus  = memref.alloc() : memref<4xf64>
      %x_minus = memref.alloc() : memref<4xf64>
      memref.copy %x, %x_plus  : memref<4xf64> to memref<4xf64>
      memref.copy %x, %x_minus : memref<4xf64> to memref<4xf64>
      %v1 = memref.load %x_plus[%rho]  : memref<4xf64>
      %v2 = arith.addf %v1, %h : f64
      memref.store %v2, %x_plus[%rho]  : memref<4xf64>
      %v3 = memref.load %x_minus[%rho] : memref<4xf64>
      %v4 = arith.subf %v3, %h : f64
      memref.store %v4, %x_minus[%rho] : memref<4xf64>
      %g_plus  = memref.alloc() : memref<4x4xf64>
      %g_minus = memref.alloc() : memref<4x4xf64>
      func.call @metric_generator(%x_plus,  %g_plus) : (memref<4xf64>, memref<4x4xf64>) -> ()
      func.call @metric_generator(%x_minus, %g_minus) : (memref<4xf64>, memref<4x4xf64>) -> ()
      scf.for %lam = %c0_idx to %c_dim step %c1_idx {
        scf.for %nu  = %c0_idx to %c_dim step %c1_idx {
          %gp = memref.load %g_plus[%lam, %nu]  : memref<4x4xf64>
          %gm = memref.load %g_minus[%lam, %nu] : memref<4x4xf64>
          %num = arith.subf %gp, %gm : f64
          %den = arith.mulf %two, %h : f64
          %val = arith.divf %num, %den : f64
          memref.store %val, %dg[%lam, %nu, %rho] : memref<4x4x4xf64>
        } }
      memref.dealloc %g_plus : memref<4x4xf64>
      memref.dealloc %g_minus : memref<4x4xf64>
      memref.dealloc %x_plus : memref<4xf64>
      memref.dealloc %x_minus : memref<4xf64>
    }
    %half = arith.constant 0.5 : f64
    scf.for %lam = %c0_idx to %c_dim step %c1_idx {
      scf.for %nu  = %c0_idx to %c_dim step %c1_idx {
        scf.for %mu  = %c0_idx to %c_dim step %c1_idx {
          %d1 = memref.load %dg[%nu, %lam, %mu] : memref<4x4x4xf64>
          %d2 = memref.load %dg[%mu, %lam, %nu] : memref<4x4x4xf64>
          %d3 = memref.load %dg[%mu, %nu, %lam] : memref<4x4x4xf64>
          %s1 = arith.addf %d1, %d2 : f64
          %s2 = arith.subf %s1, %d3 : f64
          %val = arith.mulf %half, %s2 : f64          memref.store %val, %tmp[%lam,%nu,%mu] : memref<4x4x4xf64>
        } } }
    scf.for %kap = %c0_idx to %c_dim step %c1_idx {
      scf.for %nu  = %c0_idx to %c_dim step %c1_idx {
        scf.for %mu  = %c0_idx to %c_dim step %c1_idx {
          %acc_init = arith.constant 0.0 : f64
          %acc = scf.for %lam = %c0_idx to %c_dim step %c1_idx iter_args(%acc = %acc_init) -> f64 {
            %gkl      = memref.load %ginv[%kap,%lam] : memref<4x4xf64>
            %tpl      = memref.load %tmp[%lam,%nu,%mu] : memref<4x4x4xf64>
            %prod     = arith.mulf %gkl, %tpl : f64
            %acc_next = arith.addf %acc, %prod : f64
            scf.yield %acc_next : f64
          }
          memref.store %acc, %out[%kap,%nu,%mu] : memref<4x4x4xf64>
        } } }
    return
  }
}