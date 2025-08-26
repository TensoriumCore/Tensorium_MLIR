"builtin.module"() ({
  "func.func"() <{function_type = (vector<4xf64>) -> tensor<3x3xf64>, sym_name = "SchwarzschildSpatial"}> ({
  ^bb0(%arg1: vector<4xf64>):
    %3 = "arith.constant"() <{value = 0 : index}> : () -> index
    %4 = "arith.constant"() <{value = -1.000000e+00 : f64}> : () -> f64
    %5 = "arith.constant"() <{value = 2.000000e+00 : f64}> : () -> f64
    %6 = "arith.constant"() <{value = 1.000000e-30 : f64}> : () -> f64
    %7 = "arith.constant"() <{value = 1.000000e+00 : f64}> : () -> f64
    %8 = "arith.constant"() <{value = 1 : index}> : () -> index
    %9 = "arith.constant"() <{value = 2 : index}> : () -> index
    %10 = "arith.constant"() <{value = 3 : index}> : () -> index
    %11 = "vector.extractelement"(%arg1, %8) : (vector<4xf64>, index) -> f64
    %12 = "vector.extractelement"(%arg1, %9) : (vector<4xf64>, index) -> f64
    %13 = "vector.extractelement"(%arg1, %10) : (vector<4xf64>, index) -> f64
    %14 = "arith.mulf"(%11, %11) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %15 = "arith.mulf"(%12, %12) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %16 = "arith.mulf"(%13, %13) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %17 = "arith.addf"(%14, %15) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %18 = "arith.addf"(%17, %16) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %19 = "arith.cmpf"(%18, %6) <{fastmath = #arith.fastmath<none>, predicate = 4 : i64}> : (f64, f64) -> i1
    %20 = "arith.select"(%19, %6, %18) : (i1, f64, f64) -> f64
    %21 = "math.sqrt"(%20) <{fastmath = #arith.fastmath<none>}> : (f64) -> f64
    %22 = "arith.divf"(%7, %21) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %23 = "arith.divf"(%11, %21) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %24 = "arith.divf"(%12, %21) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %25 = "arith.divf"(%13, %21) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %26 = "arith.mulf"(%22, %5) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %27 = "arith.addf"(%26, %4) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %28 = "arith.mulf"(%26, %23) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %29 = "arith.mulf"(%26, %24) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %30 = "arith.mulf"(%26, %25) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %31 = "arith.mulf"(%23, %23) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %32 = "arith.mulf"(%23, %24) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %33 = "arith.mulf"(%23, %25) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %34 = "arith.mulf"(%24, %24) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %35 = "arith.mulf"(%24, %25) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %36 = "arith.mulf"(%25, %25) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %37 = "arith.mulf"(%26, %31) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %38 = "arith.mulf"(%26, %32) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %39 = "arith.mulf"(%26, %33) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %40 = "arith.mulf"(%26, %34) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %41 = "arith.mulf"(%26, %35) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %42 = "arith.mulf"(%26, %36) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %43 = "arith.addf"(%37, %7) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %44 = "arith.addf"(%40, %7) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %45 = "arith.addf"(%42, %7) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %46 = "tensor.empty"() : () -> tensor<4x4xf64>
    %47 = "tensor.insert"(%27, %46, %3, %3) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %48 = "tensor.insert"(%28, %47, %3, %8) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %49 = "tensor.insert"(%29, %48, %3, %9) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %50 = "tensor.insert"(%30, %49, %3, %10) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %51 = "tensor.insert"(%28, %50, %8, %3) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %52 = "tensor.insert"(%43, %51, %8, %8) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %53 = "tensor.insert"(%38, %52, %8, %9) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %54 = "tensor.insert"(%39, %53, %8, %10) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %55 = "tensor.insert"(%29, %54, %9, %3) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %56 = "tensor.insert"(%38, %55, %9, %8) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %57 = "tensor.insert"(%44, %56, %9, %9) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %58 = "tensor.insert"(%41, %57, %9, %10) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %59 = "tensor.insert"(%30, %58, %10, %3) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %60 = "tensor.insert"(%39, %59, %10, %8) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %61 = "tensor.insert"(%41, %60, %10, %9) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %62 = "tensor.insert"(%45, %61, %10, %10) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %63 = "tensor.empty"() : () -> tensor<3x3xf64>
    %64 = "tensor.extract"(%62, %8, %8) : (tensor<4x4xf64>, index, index) -> f64
    %65 = "tensor.insert"(%64, %63, %3, %3) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %66 = "tensor.extract"(%62, %8, %9) : (tensor<4x4xf64>, index, index) -> f64
    %67 = "tensor.insert"(%66, %65, %3, %8) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %68 = "tensor.extract"(%62, %8, %10) : (tensor<4x4xf64>, index, index) -> f64
    %69 = "tensor.insert"(%68, %67, %3, %9) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %70 = "tensor.extract"(%62, %9, %8) : (tensor<4x4xf64>, index, index) -> f64
    %71 = "tensor.insert"(%70, %69, %8, %3) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %72 = "tensor.extract"(%62, %9, %9) : (tensor<4x4xf64>, index, index) -> f64
    %73 = "tensor.insert"(%72, %71, %8, %8) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %74 = "tensor.extract"(%62, %9, %10) : (tensor<4x4xf64>, index, index) -> f64
    %75 = "tensor.insert"(%74, %73, %8, %9) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %76 = "tensor.extract"(%62, %10, %8) : (tensor<4x4xf64>, index, index) -> f64
    %77 = "tensor.insert"(%76, %75, %9, %3) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %78 = "tensor.extract"(%62, %10, %9) : (tensor<4x4xf64>, index, index) -> f64
    %79 = "tensor.insert"(%78, %77, %9, %8) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %80 = "tensor.insert"(%45, %79, %9, %9) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    "func.return"(%80) : (tensor<3x3xf64>) -> ()
  }) : () -> ()
  "func.func"() <{function_type = (vector<4xf64>) -> (f64, tensor<3x3xf64>), sym_name = "DetInvGamma"}> ({
  ^bb0(%arg0: vector<4xf64>):
    %0 = "func.call"(%arg0) <{callee = @SchwarzschildSpatial}> : (vector<4xf64>) -> tensor<3x3xf64>
    %1 = "relativity.det3x3"(%0) : (tensor<3x3xf64>) -> f64
    %2 = "relativity.inv3x3"(%0) : (tensor<3x3xf64>) -> tensor<3x3xf64>
    "func.return"(%1, %2) : (f64, tensor<3x3xf64>) -> ()
  }) : () -> ()
}) : () -> ()

