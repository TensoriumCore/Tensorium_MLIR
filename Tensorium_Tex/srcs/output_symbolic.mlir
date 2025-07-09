func.func @g_tt(%M: f64, %_rho: f64, %r: f64) -> f64 {
  %9 = relativity.metric_component %M, %_rho, %r {indices = ["t", "t"], formula = "-1 - frac{2 M}{rho^{2}}"} : f64, f64, f64 -> f64
  return %9 : f64
}

func.func @g_phit(%M: f64, %_rho: f64, %_sin: f64, %_theta: f64, %a: f64, %r: f64) -> f64 {
  %7 = relativity.metric_component %M, %_rho, %_sin, %_theta, %a, %r {indices = ["phi", "t"], formula = "-frac{4 M}{rho^{2}}"} : f64, f64, f64, f64, f64, f64 -> f64
  return %7 : f64
}

func.func @g_rr(%_Delta: f64, %_rho: f64) -> f64 {
  %3 = relativity.metric_component %_Delta, %_rho {indices = ["r", "r"], formula = "frac{rho^{2}}{Delta}"} : f64, f64 -> f64
  return %3 : f64
}

func.func @g_thetatheta(%_rho: f64) -> f64 {
  %2 = relativity.metric_component %_rho {indices = ["theta", "theta"], formula = "rho^{2}"} : f64 -> f64
  return %2 : f64
}

func.func @g_phiphi(%M: f64, %_rho: f64, %_sin: f64, %_theta: f64, %a: f64, %r: f64) -> f64 {
  %19 = relativity.metric_component %M, %_rho, %_sin, %_theta, %a, %r {indices = ["phi", "phi"], formula = "r^{2} + a^{2} sin^{2} theta + frac{2 M}{rho^{2}} sin^{2} theta"} : f64, f64, f64, f64, f64, f64 -> f64
  return %19 : f64
}

