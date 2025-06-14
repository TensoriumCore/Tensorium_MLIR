module {
  func.func @flrw_flat(%m: f64, %r: f64, %t: f64, %theta: f64, %phi: f64, %a: f64, %x: f64, %y: f64, %z: f64, %dx: f64, %dy: f64, %dz: f64, %dt: f64, %dr: f64, %dtheta: f64, %dphi: f64) -> f64 {
    %x0 = arith.mulf %r, %r : f64
    %c1 = arith.constant -1.0 : f64
    %x2 = arith.mulf %dt, %dt : f64
    %x3 = arith.mulf %c1, %x2 : f64
    %x4 = arith.mulf %a, %a : f64
    %x5 = arith.mulf %dr, %dr : f64
    %x6 = arith.mulf %dtheta, %dtheta : f64
    %x7 = arith.mulf %x0, %x6 : f64
    %x8 = arith.mulf %dphi, %dphi : f64
    %x9 = arith.mulf %theta, %x8 : f64
    %x10 = math.sin %x9 : f64
    %x11 = arith.mulf %x10, %x10 : f64
    %x12 = arith.mulf %x0, %x11 : f64
    %x13 = arith.addf %x5, %x7 : f64
    %x14 = arith.addf %x13, %x12 : f64
    %x15 = arith.mulf %x4, %x14 : f64
    %x16 = arith.addf %x3, %x15 : f64
    %result = arith.addf %x16, %x16 : f64
    return %result : f64
  }
}