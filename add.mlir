
module {
  func.func @add(%a: f64, %b: f64) -> f64 {
    %sum = arith.addf %a, %b : f64
    return %sum : f64
  }

  func.func @sub(%a: f64, %b: f64) -> f64 {
	  %sub = arith.subf %a, %b : f64
	  return %sub : f64
  }
}


