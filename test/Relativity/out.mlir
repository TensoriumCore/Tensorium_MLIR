module {
  func.func private @metric_component_impl(f64, f64, f64, f64, f64, f64, f64) -> f64
  func.func @metric_tensor(%arg0: f64, %arg1: f64, %arg2: f64, %arg3: f64, %arg4: f64) -> tensor<4x4xf64> {
    %cst = arith.constant 0.000000e+00 : f64
    %cst_0 = arith.constant 4.000000e+00 : f64
    %cst_1 = arith.constant 2.000000e+00 : f64
    %0 = math.powf %arg4, %cst_1 : f64
    %1 = math.sin %arg2 : f64
    %2 = arith.mulf %0, %1 : f64
    %3 = math.powf %arg2, %cst_1 : f64
    %4 = arith.mulf %2, %3 : f64
    %5 = math.powf %arg1, %cst_1 : f64
    %6 = math.sin %arg2 : f64
    %7 = arith.mulf %5, %6 : f64
    %8 = math.powf %arg2, %cst_1 : f64
    %9 = arith.mulf %7, %8 : f64
    %10 = arith.addf %4, %9 : f64
    %11 = arith.mulf %arg0, %cst_0 : f64
    %12 = arith.mulf %11, %arg1 : f64
    %13 = arith.mulf %12, %arg4 : f64
    %14 = math.sin %arg2 : f64
    %15 = arith.mulf %13, %14 : f64
    %16 = math.powf %arg2, %cst_1 : f64
    %17 = arith.mulf %15, %16 : f64
    %18 = arith.negf %17 : f64
    %19 = arith.mulf %arg4, %arg4 : f64
    %20 = arith.mulf %arg1, %arg1 : f64
    %21 = math.cos %arg2 : f64
    %22 = arith.mulf %21, %21 : f64
    %23 = arith.mulf %20, %22 : f64
    %24 = arith.addf %19, %23 : f64
    %25 = math.sqrt %24 : f64
    %26 = math.powf %25, %cst_1 : f64
    %27 = arith.divf %18, %26 : f64
    %28 = arith.mulf %arg4, %arg4 : f64
    %29 = arith.mulf %arg1, %arg1 : f64
    %30 = math.cos %arg2 : f64
    %31 = arith.mulf %30, %30 : f64
    %32 = arith.mulf %29, %31 : f64
    %33 = arith.addf %28, %32 : f64
    %34 = math.sqrt %33 : f64
    %35 = math.powf %34, %cst_1 : f64
    %36 = arith.mulf %arg4, %arg4 : f64
    %37 = arith.mulf %arg1, %arg1 : f64
    %38 = arith.mulf %arg0, %arg4 : f64
    %39 = arith.mulf %38, %cst_1 : f64
    %40 = arith.subf %36, %39 : f64
    %41 = arith.addf %40, %37 : f64
    %42 = arith.divf %35, %41 : f64
    %43 = arith.mulf %arg4, %arg4 : f64
    %44 = arith.mulf %arg1, %arg1 : f64
    %45 = math.cos %arg2 : f64
    %46 = arith.mulf %45, %45 : f64
    %47 = arith.mulf %44, %46 : f64
    %48 = arith.addf %43, %47 : f64
    %49 = math.sqrt %48 : f64
    %50 = math.powf %49, %cst_1 : f64
    %from_elements = tensor.from_elements %10, %cst, %cst, %cst, %cst, %27, %cst, %cst, %cst, %cst, %42, %cst, %cst, %cst, %cst, %50 : tensor<4x4xf64>
    return %from_elements : tensor<4x4xf64>
  }
}

