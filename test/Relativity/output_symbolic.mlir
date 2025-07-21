func.func @metric_tensor(%M: f64, %a: f64, %theta: f64, %phi: f64, %r: f64) -> tensor<4x4xf64> {
  %0 = relativity.metric_component %M, %a, %theta, %phi, %r {indices = ["phi", "phi"], formula = "((r^2 * sin(theta)^2) + (a^2 * sin(theta)^2))"} : f64, f64, f64, f64, f64 -> f64
  %1 = relativity.metric_component %M, %a, %theta, %phi, %r {indices = ["phi", "t"], formula = "-((4 * M * a * r * sin(theta)^2))/(rho^2)"} : f64, f64, f64, f64, f64 -> f64
  %2 = relativity.metric_component %M, %a, %theta, %phi, %r {indices = ["r", "r"], formula = "(rho^2)/(Delta)"} : f64, f64, f64, f64, f64 -> f64
  %3 = relativity.metric_component %M, %a, %theta, %phi, %r {indices = ["t", "t"], formula = "-(1 - ((2 * M * r))/(rho^2))"} : f64, f64, f64, f64, f64 -> f64
  %4 = relativity.metric_component %M, %a, %theta, %phi, %r {indices = ["theta", "theta"], formula = "rho^2"} : f64, f64, f64, f64, f64 -> f64
  %tensor = relativity.metric_tensor %0, %1, %2, %3, %4 : f64, f64, f64, f64, f64 -> tensor<4x4xf64>
  return %tensor : tensor<4x4xf64>
}
