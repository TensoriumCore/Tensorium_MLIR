"builtin.module"() ({
  "func.func"() <{function_type = (vector<4xf64>) -> tensor<4x4xf64>, sym_name = "Shcwarzschild"}> ({
  ^bb0(%arg0: vector<4xf64>):
    %0 = "arith.constant"() <{value = 0 : index}> : () -> index
    %1 = "arith.constant"() <{value = -1.000000e+00 : f64}> : () -> f64
    %2 = "arith.constant"() <{value = 2.000000e+00 : f64}> : () -> f64
    %3 = "arith.constant"() <{value = 1.000000e-30 : f64}> : () -> f64
    %4 = "arith.constant"() <{value = 1.000000e+00 : f64}> : () -> f64
    %5 = "arith.constant"() <{value = 1 : index}> : () -> index
    %6 = "arith.constant"() <{value = 2 : index}> : () -> index
    %7 = "arith.constant"() <{value = 3 : index}> : () -> index
    %8 = "vector.extractelement"(%arg0, %5) : (vector<4xf64>, index) -> f64
    %9 = "vector.extractelement"(%arg0, %6) : (vector<4xf64>, index) -> f64
    %10 = "vector.extractelement"(%arg0, %7) : (vector<4xf64>, index) -> f64
    %11 = "arith.mulf"(%8, %8) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %12 = "arith.mulf"(%9, %9) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %13 = "arith.mulf"(%10, %10) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %14 = "arith.addf"(%11, %12) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %15 = "arith.addf"(%14, %13) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %16 = "arith.cmpf"(%15, %3) <{fastmath = #arith.fastmath<none>, predicate = 4 : i64}> : (f64, f64) -> i1
    %17 = "arith.select"(%16, %3, %15) : (i1, f64, f64) -> f64
    %18 = "math.sqrt"(%17) <{fastmath = #arith.fastmath<none>}> : (f64) -> f64
    %19 = "arith.divf"(%4, %18) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %20 = "arith.divf"(%8, %18) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %21 = "arith.divf"(%9, %18) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %22 = "arith.divf"(%10, %18) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %23 = "arith.mulf"(%19, %2) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %24 = "arith.addf"(%23, %1) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %25 = "arith.mulf"(%23, %20) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %26 = "arith.mulf"(%23, %21) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %27 = "arith.mulf"(%23, %22) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %28 = "arith.mulf"(%20, %20) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %29 = "arith.mulf"(%20, %21) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %30 = "arith.mulf"(%20, %22) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %31 = "arith.mulf"(%21, %21) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %32 = "arith.mulf"(%21, %22) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %33 = "arith.mulf"(%22, %22) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %34 = "arith.mulf"(%23, %28) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %35 = "arith.mulf"(%23, %29) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %36 = "arith.mulf"(%23, %30) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %37 = "arith.mulf"(%23, %31) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %38 = "arith.mulf"(%23, %32) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %39 = "arith.mulf"(%23, %33) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %40 = "arith.addf"(%34, %4) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %41 = "arith.addf"(%37, %4) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %42 = "arith.addf"(%39, %4) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %43 = "tensor.empty"() : () -> tensor<4x4xf64>
    %44 = "tensor.insert"(%24, %43, %0, %0) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %45 = "tensor.insert"(%25, %44, %0, %5) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %46 = "tensor.insert"(%26, %45, %0, %6) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %47 = "tensor.insert"(%27, %46, %0, %7) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %48 = "tensor.insert"(%25, %47, %5, %0) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %49 = "tensor.insert"(%40, %48, %5, %5) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %50 = "tensor.insert"(%35, %49, %5, %6) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %51 = "tensor.insert"(%36, %50, %5, %7) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %52 = "tensor.insert"(%26, %51, %6, %0) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %53 = "tensor.insert"(%35, %52, %6, %5) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %54 = "tensor.insert"(%41, %53, %6, %6) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %55 = "tensor.insert"(%38, %54, %6, %7) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %56 = "tensor.insert"(%27, %55, %7, %0) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %57 = "tensor.insert"(%36, %56, %7, %5) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %58 = "tensor.insert"(%38, %57, %7, %6) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %59 = "tensor.insert"(%42, %58, %7, %7) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    "func.return"(%59) : (tensor<4x4xf64>) -> ()
  }) : () -> ()
}) : () -> ()

