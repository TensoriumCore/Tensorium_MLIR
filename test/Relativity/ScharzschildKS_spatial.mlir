"builtin.module"() ({
  "func.func"() <{function_type = (vector<4xf64>) -> tensor<4x4xf64>, sym_name = "Schwarzschild"}> ({
  ^bb0(%arg1: vector<4xf64>):
    %78 = "arith.constant"() <{value = 0 : index}> : () -> index
    %79 = "arith.constant"() <{value = -1.000000e+00 : f64}> : () -> f64
    %80 = "arith.constant"() <{value = 2.000000e+00 : f64}> : () -> f64
    %81 = "arith.constant"() <{value = 1.000000e-30 : f64}> : () -> f64
    %82 = "arith.constant"() <{value = 1.000000e+00 : f64}> : () -> f64
    %83 = "arith.constant"() <{value = 1 : index}> : () -> index
    %84 = "arith.constant"() <{value = 2 : index}> : () -> index
    %85 = "arith.constant"() <{value = 3 : index}> : () -> index
    %86 = "vector.extractelement"(%arg1, %83) : (vector<4xf64>, index) -> f64
    %87 = "vector.extractelement"(%arg1, %84) : (vector<4xf64>, index) -> f64
    %88 = "vector.extractelement"(%arg1, %85) : (vector<4xf64>, index) -> f64
    %89 = "arith.mulf"(%86, %86) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %90 = "arith.mulf"(%87, %87) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %91 = "arith.mulf"(%88, %88) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %92 = "arith.addf"(%89, %90) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %93 = "arith.addf"(%92, %91) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %94 = "arith.cmpf"(%93, %81) <{fastmath = #arith.fastmath<none>, predicate = 4 : i64}> : (f64, f64) -> i1
    %95 = "arith.select"(%94, %81, %93) : (i1, f64, f64) -> f64
    %96 = "math.sqrt"(%95) <{fastmath = #arith.fastmath<none>}> : (f64) -> f64
    %97 = "arith.divf"(%82, %96) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %98 = "arith.divf"(%86, %96) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %99 = "arith.divf"(%87, %96) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %100 = "arith.divf"(%88, %96) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %101 = "arith.mulf"(%97, %80) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %102 = "arith.addf"(%101, %79) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %103 = "arith.mulf"(%101, %98) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %104 = "arith.mulf"(%101, %99) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %105 = "arith.mulf"(%101, %100) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %106 = "arith.mulf"(%98, %98) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %107 = "arith.mulf"(%98, %99) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %108 = "arith.mulf"(%98, %100) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %109 = "arith.mulf"(%99, %99) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %110 = "arith.mulf"(%99, %100) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %111 = "arith.mulf"(%100, %100) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %112 = "arith.mulf"(%101, %106) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %113 = "arith.mulf"(%101, %107) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %114 = "arith.mulf"(%101, %108) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %115 = "arith.mulf"(%101, %109) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %116 = "arith.mulf"(%101, %110) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %117 = "arith.mulf"(%101, %111) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %118 = "arith.addf"(%112, %82) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %119 = "arith.addf"(%115, %82) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %120 = "arith.addf"(%117, %82) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %121 = "tensor.empty"() : () -> tensor<4x4xf64>
    %122 = "tensor.insert"(%102, %121, %78, %78) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %123 = "tensor.insert"(%103, %122, %78, %83) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %124 = "tensor.insert"(%104, %123, %78, %84) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %125 = "tensor.insert"(%105, %124, %78, %85) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %126 = "tensor.insert"(%103, %125, %83, %78) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %127 = "tensor.insert"(%118, %126, %83, %83) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %128 = "tensor.insert"(%113, %127, %83, %84) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %129 = "tensor.insert"(%114, %128, %83, %85) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %130 = "tensor.insert"(%104, %129, %84, %78) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %131 = "tensor.insert"(%113, %130, %84, %83) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %132 = "tensor.insert"(%119, %131, %84, %84) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %133 = "tensor.insert"(%116, %132, %84, %85) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %134 = "tensor.insert"(%105, %133, %85, %78) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %135 = "tensor.insert"(%114, %134, %85, %83) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %136 = "tensor.insert"(%116, %135, %85, %84) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %137 = "tensor.insert"(%120, %136, %85, %85) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    "func.return"(%137) : (tensor<4x4xf64>) -> ()
  }) : () -> ()
  "func.func"() <{function_type = (vector<4xf64>) -> tensor<3x3xf64>, sym_name = "SchwarzschildSpatial"}> ({
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
    %60 = "tensor.empty"() : () -> tensor<3x3xf64>
    %61 = "tensor.extract"(%59, %5, %5) : (tensor<4x4xf64>, index, index) -> f64
    %62 = "tensor.insert"(%61, %60, %0, %0) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %63 = "tensor.extract"(%59, %5, %6) : (tensor<4x4xf64>, index, index) -> f64
    %64 = "tensor.insert"(%63, %62, %0, %5) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %65 = "tensor.extract"(%59, %5, %7) : (tensor<4x4xf64>, index, index) -> f64
    %66 = "tensor.insert"(%65, %64, %0, %6) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %67 = "tensor.extract"(%59, %6, %5) : (tensor<4x4xf64>, index, index) -> f64
    %68 = "tensor.insert"(%67, %66, %5, %0) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %69 = "tensor.extract"(%59, %6, %6) : (tensor<4x4xf64>, index, index) -> f64
    %70 = "tensor.insert"(%69, %68, %5, %5) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %71 = "tensor.extract"(%59, %6, %7) : (tensor<4x4xf64>, index, index) -> f64
    %72 = "tensor.insert"(%71, %70, %5, %6) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %73 = "tensor.extract"(%59, %7, %5) : (tensor<4x4xf64>, index, index) -> f64
    %74 = "tensor.insert"(%73, %72, %6, %0) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %75 = "tensor.extract"(%59, %7, %6) : (tensor<4x4xf64>, index, index) -> f64
    %76 = "tensor.insert"(%75, %74, %6, %5) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %77 = "tensor.insert"(%42, %76, %6, %6) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    "func.return"(%77) : (tensor<3x3xf64>) -> ()
  }) : () -> ()
}) : () -> ()

