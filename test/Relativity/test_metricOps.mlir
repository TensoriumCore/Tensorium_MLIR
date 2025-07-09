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

func.func @assemble_metric(%M: f64, %_rho: f64, %_sin: f64, %_theta: f64, %a: f64, %r: f64, %_Delta: f64) -> tensor<3x3xf64> {
  // Compute all the needed components
  %gtt = call @g_tt(%M, %_rho, %r) : (f64, f64, f64) -> f64
  %gphit = call @g_phit(%M, %_rho, %_sin, %_theta, %a, %r) : (f64, f64, f64, f64, f64, f64) -> f64
  %grr = call @g_rr(%_Delta, %_rho) : (f64, f64) -> f64
  %gthetatheta = call @g_thetatheta(%_rho) : (f64) -> f64
  %gphiphi = call @g_phiphi(%M, %_rho, %_sin, %_theta, %a, %r) : (f64, f64, f64, f64, f64, f64) -> f64

  %metric = relativity.metric_tensor %gtt, %grr, %gthetatheta, %gphiphi, %gphit : f64, f64, f64, f64, f64 -> tensor<3x3xf64>
  return %metric : tensor<3x3xf64>
}
