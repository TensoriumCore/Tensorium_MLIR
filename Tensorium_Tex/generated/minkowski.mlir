module {
  func.func @minkowski(%m: f64, %r: f64, %t: f64, %theta: f64, %phi: f64, %a: f64, %x: f64, %y: f64, %z: f64, %dx: f64, %dy: f64, %dz: f64, %dt: f64, %dr: f64, %dtheta: f64, %dphi: f64) -> f64 {
    %x0 = arith.mulf %r, %r : f64
    %x1 = arith.mulf %dr, %dr : f64
    %c2 = arith.constant -1.0 : f64
    %x3 = arith.mulf %dt, %dt : f64
    %x4 = arith.mulf %c2, %x3 : f64
    %x5 = arith.mulf %dtheta, %dtheta : f64
    %x6 = arith.mulf %x0, %x5 : f64
    %x7 = arith.mulf %dphi, %dphi : f64
    %x8 = arith.mulf %theta, %x7 : f64
    %x9 = math.sin %x8 : f64
    %x10 = arith.mulf %x9, %x9 : f64
    %x11 = arith.mulf %x0, %x10 : f64
    %x12 = arith.addf %x1, %x4 : f64
    %x13 = arith.addf %x12, %x6 : f64
    %x14 = arith.addf %x13, %x11 : f64
    %result = arith.addf %x14, %x14 : f64
    return %result : f64
  }
}