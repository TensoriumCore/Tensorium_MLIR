"builtin.module"() ({
  "func.func"() <{function_type = (vector<4xf64>) -> tensor<4x4xf64>, sym_name = "main"}> ({
  ^bb0(%arg0: vector<4xf64>):
    %0 = "arith.constant"() <{value = 0 : index}> : () -> index
    %1 = "arith.constant"() <{value = -1.000000e+00 : f64}> : () -> f64
    %2 = "arith.constant"() <{value = 2.000000e+00 : f64}> : () -> f64
    %3 = "arith.constant"() <{value = 1.000000e+00 : f64}> : () -> f64
    %4 = "arith.constant"() <{value = 1 : index}> : () -> index
    %5 = "arith.constant"() <{value = 2 : index}> : () -> index
    %6 = "arith.constant"() <{value = 3 : index}> : () -> index
    %7 = "vector.extractelement"(%arg0, %4) : (vector<4xf64>, index) -> f64
    %8 = "vector.extractelement"(%arg0, %5) : (vector<4xf64>, index) -> f64
    %9 = "vector.extractelement"(%arg0, %6) : (vector<4xf64>, index) -> f64
    %10 = "arith.mulf"(%7, %7) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %11 = "arith.mulf"(%8, %8) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %12 = "arith.mulf"(%9, %9) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %13 = "arith.addf"(%10, %11) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %14 = "arith.addf"(%13, %12) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %15 = "math.sqrt"(%14) <{fastmath = #arith.fastmath<none>}> : (f64) -> f64
    %16 = "arith.divf"(%3, %15) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %17 = "arith.divf"(%7, %15) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %18 = "arith.divf"(%8, %15) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %19 = "arith.divf"(%9, %15) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %20 = "arith.mulf"(%16, %2) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %21 = "arith.addf"(%20, %1) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %22 = "arith.mulf"(%20, %17) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %23 = "arith.mulf"(%20, %18) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %24 = "arith.mulf"(%20, %19) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %25 = "arith.mulf"(%17, %17) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %26 = "arith.mulf"(%17, %18) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %27 = "arith.mulf"(%17, %19) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %28 = "arith.mulf"(%18, %18) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %29 = "arith.mulf"(%18, %19) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %30 = "arith.mulf"(%19, %19) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %31 = "arith.mulf"(%20, %25) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %32 = "arith.mulf"(%20, %26) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %33 = "arith.mulf"(%20, %27) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %34 = "arith.mulf"(%20, %28) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %35 = "arith.mulf"(%20, %29) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %36 = "arith.mulf"(%20, %30) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %37 = "arith.addf"(%31, %3) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %38 = "arith.addf"(%34, %3) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %39 = "arith.addf"(%36, %3) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %40 = "tensor.empty"() : () -> tensor<4x4xf64>
    %41 = "tensor.insert"(%21, %40, %0, %0) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %42 = "tensor.insert"(%22, %41, %0, %4) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %43 = "tensor.insert"(%23, %42, %0, %5) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %44 = "tensor.insert"(%24, %43, %0, %6) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %45 = "tensor.insert"(%22, %44, %4, %0) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %46 = "tensor.insert"(%37, %45, %4, %4) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %47 = "tensor.insert"(%32, %46, %4, %5) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %48 = "tensor.insert"(%33, %47, %4, %6) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %49 = "tensor.insert"(%23, %48, %5, %0) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %50 = "tensor.insert"(%32, %49, %5, %4) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %51 = "tensor.insert"(%38, %50, %5, %5) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %52 = "tensor.insert"(%35, %51, %5, %6) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %53 = "tensor.insert"(%24, %52, %6, %0) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %54 = "tensor.insert"(%33, %53, %6, %4) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %55 = "tensor.insert"(%35, %54, %6, %5) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %56 = "tensor.insert"(%39, %55, %6, %6) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    "func.return"(%56) : (tensor<4x4xf64>) -> ()
  }) : () -> ()
}) : () -> ()

