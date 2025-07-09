func.func @g_tt(%M: f64, %_rho: f64, %r: f64) {
  %0 = arith.constant 1.0 : f64
  %1 = arith.constant 2.0 : f64
  %2 = arith.mulf %1, %M : f64
  %3 = arith.constant 2.0 : f64
  %4 = math.powf %_rho, %3 : f64
  %5 = arith.divf %2, %4 : f64
  %6 = arith.subf %0, %5 : f64
  %7 = arith.constant 0.0 : f64
  %8 = arith.subf %7, %6 : f64
  return
}

func.func @g_phit(%M: f64, %_rho: f64, %_sin: f64, %_theta: f64, %a: f64, %r: f64) {
  %0 = arith.constant 4.0 : f64
  %1 = arith.mulf %0, %M : f64
  %2 = arith.constant 2.0 : f64
  %3 = math.powf %_rho, %2 : f64
  %4 = arith.divf %1, %3 : f64
  %5 = arith.constant 0.0 : f64
  %6 = arith.subf %5, %4 : f64
  return
}

func.func @g_rr(%_Delta: f64, %_rho: f64) {
  %0 = arith.constant 2.0 : f64
  %1 = math.powf %_rho, %0 : f64
  %2 = arith.divf %1, %_Delta : f64
  return
}

func.func @g_thetatheta(%_rho: f64) {
  %0 = arith.constant 2.0 : f64
  %1 = math.powf %_rho, %0 : f64
  return
}

func.func @g_phiphi(%M: f64, %_rho: f64, %_sin: f64, %_theta: f64, %a: f64, %r: f64) {
  %0 = arith.constant 2.0 : f64
  %1 = math.powf %r, %0 : f64
  %2 = arith.addf %1, %a : f64
  %3 = arith.constant 2.0 : f64
  %4 = math.powf %2, %3 : f64
  %5 = arith.constant 2.0 : f64
  %6 = math.powf %_sin, %5 : f64
  %7 = arith.mulf %4, %6 : f64
  %8 = arith.mulf %7, %_theta : f64
  %9 = arith.constant 2.0 : f64
  %10 = arith.mulf %9, %M : f64
  %11 = arith.constant 2.0 : f64
  %12 = math.powf %_rho, %11 : f64
  %13 = arith.divf %10, %12 : f64
  %14 = arith.constant 2.0 : f64
  %15 = math.powf %_sin, %14 : f64
  %16 = arith.mulf %13, %15 : f64
  %17 = arith.mulf %16, %_theta : f64
  %18 = arith.addf %8, %17 : f64
  return
}

