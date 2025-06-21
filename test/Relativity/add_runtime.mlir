func.func @main(%a: f64, %b: f64) -> f64 {
  %r = relativity.add %a, %b : f64
  return %r : f64
}
