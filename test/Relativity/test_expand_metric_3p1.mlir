"builtin.module"() ({
  "func.func"() <{function_type = (tensor<10x4xf64>) -> (tensor<10xf64>, tensor<10x3xf64>, tensor<10x3x3xf64>), sym_name = "GridMetric1D"}> ({
  ^bb0(%arg0: tensor<10x4xf64>):
    %0 = "arith.constant"() <{value = 0.000000e+00 : f64}> : () -> f64
    %1 = "arith.constant"() <{value = 2.000000e+00 : f64}> : () -> f64
    %2 = "arith.constant"() <{value = -1.000000e+00 : f64}> : () -> f64
    %3 = "arith.constant"() <{value = 1.000000e-30 : f64}> : () -> f64
    %4 = "arith.constant"() <{value = 1.000000e+00 : f64}> : () -> f64
    %5 = "arith.constant"() <{value = 3 : index}> : () -> index
    %6 = "arith.constant"() <{value = 2 : index}> : () -> index
    %7 = "arith.constant"() <{value = 1 : index}> : () -> index
    %8 = "arith.constant"() <{value = 10 : index}> : () -> index
    %9 = "arith.constant"() <{value = 0 : index}> : () -> index
    %10 = "tensor.empty"() : () -> tensor<10xf64>
    %11 = "tensor.empty"() : () -> tensor<10x3xf64>
    %12 = "tensor.empty"() : () -> tensor<10x3x3xf64>
    %13:3 = "scf.for"(%9, %8, %7, %10, %11, %12) ({
    ^bb0(%arg1: index, %arg2: tensor<10xf64>, %arg3: tensor<10x3xf64>, %arg4: tensor<10x3x3xf64>):
      %14 = "tensor.extract"(%arg0, %arg1, %7) : (tensor<10x4xf64>, index, index) -> f64
      %15 = "tensor.extract"(%arg0, %arg1, %6) : (tensor<10x4xf64>, index, index) -> f64
      %16 = "tensor.extract"(%arg0, %arg1, %5) : (tensor<10x4xf64>, index, index) -> f64
      %17 = "arith.mulf"(%14, %14) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %18 = "arith.mulf"(%15, %15) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %19 = "arith.mulf"(%16, %16) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %20 = "arith.addf"(%17, %18) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %21 = "arith.addf"(%20, %19) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %22 = "arith.cmpf"(%21, %3) <{fastmath = #arith.fastmath<none>, predicate = 4 : i64}> : (f64, f64) -> i1
      %23 = "arith.select"(%22, %3, %21) : (i1, f64, f64) -> f64
      %24 = "math.sqrt"(%23) <{fastmath = #arith.fastmath<none>}> : (f64) -> f64
      %25 = "arith.divf"(%4, %24) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %26 = "arith.divf"(%14, %24) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %27 = "arith.divf"(%15, %24) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %28 = "arith.divf"(%16, %24) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %29 = "arith.mulf"(%25, %1) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %30 = "arith.addf"(%29, %2) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %31 = "arith.mulf"(%29, %26) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %32 = "arith.mulf"(%29, %27) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %33 = "arith.mulf"(%29, %28) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %34 = "arith.mulf"(%26, %26) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %35 = "arith.mulf"(%29, %34) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %36 = "arith.addf"(%35, %4) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %37 = "arith.mulf"(%26, %27) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %38 = "arith.mulf"(%29, %37) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %39 = "arith.mulf"(%26, %28) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %40 = "arith.mulf"(%29, %39) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %41 = "arith.mulf"(%27, %26) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %42 = "arith.mulf"(%29, %41) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %43 = "arith.mulf"(%27, %27) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %44 = "arith.mulf"(%29, %43) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %45 = "arith.addf"(%44, %4) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %46 = "arith.mulf"(%27, %28) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %47 = "arith.mulf"(%29, %46) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %48 = "arith.mulf"(%28, %26) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %49 = "arith.mulf"(%29, %48) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %50 = "arith.mulf"(%28, %27) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %51 = "arith.mulf"(%29, %50) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %52 = "arith.mulf"(%28, %28) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %53 = "arith.mulf"(%29, %52) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %54 = "arith.addf"(%53, %4) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %55 = "arith.mulf"(%45, %54) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %56 = "arith.mulf"(%47, %51) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %57 = "arith.subf"(%55, %56) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %58 = "arith.mulf"(%47, %49) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %59 = "arith.mulf"(%42, %54) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %60 = "arith.subf"(%58, %59) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %61 = "arith.mulf"(%42, %51) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %62 = "arith.mulf"(%45, %49) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %63 = "arith.subf"(%61, %62) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %64 = "arith.mulf"(%40, %51) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %65 = "arith.mulf"(%38, %54) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %66 = "arith.subf"(%64, %65) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %67 = "arith.mulf"(%36, %54) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %68 = "arith.mulf"(%40, %49) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %69 = "arith.subf"(%67, %68) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %70 = "arith.mulf"(%38, %49) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %71 = "arith.mulf"(%36, %51) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %72 = "arith.subf"(%70, %71) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %73 = "arith.mulf"(%38, %47) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %74 = "arith.mulf"(%40, %45) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %75 = "arith.subf"(%73, %74) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %76 = "arith.mulf"(%40, %42) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %77 = "arith.mulf"(%36, %47) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %78 = "arith.subf"(%76, %77) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %79 = "arith.mulf"(%36, %45) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %80 = "arith.mulf"(%38, %42) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %81 = "arith.subf"(%79, %80) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %82 = "arith.mulf"(%36, %57) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %83 = "arith.mulf"(%38, %60) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %84 = "arith.mulf"(%40, %63) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %85 = "arith.addf"(%83, %84) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %86 = "arith.addf"(%82, %85) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %87 = "arith.divf"(%57, %86) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %88 = "arith.divf"(%66, %86) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %89 = "arith.divf"(%75, %86) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %90 = "arith.divf"(%60, %86) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %91 = "arith.divf"(%69, %86) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %92 = "arith.divf"(%78, %86) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %93 = "arith.divf"(%63, %86) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %94 = "arith.divf"(%72, %86) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %95 = "arith.divf"(%81, %86) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %96 = "arith.mulf"(%87, %31) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %97 = "arith.addf"(%96, %0) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %98 = "arith.mulf"(%88, %32) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %99 = "arith.addf"(%97, %98) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %100 = "arith.mulf"(%89, %33) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %101 = "arith.addf"(%99, %100) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %102 = "arith.mulf"(%90, %31) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %103 = "arith.addf"(%102, %0) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %104 = "arith.mulf"(%91, %32) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %105 = "arith.addf"(%103, %104) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %106 = "arith.mulf"(%92, %33) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %107 = "arith.addf"(%105, %106) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %108 = "arith.mulf"(%93, %31) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %109 = "arith.addf"(%108, %0) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %110 = "arith.mulf"(%94, %32) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %111 = "arith.addf"(%109, %110) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %112 = "arith.mulf"(%95, %33) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %113 = "arith.addf"(%111, %112) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %114 = "arith.mulf"(%101, %31) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %115 = "arith.addf"(%114, %0) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %116 = "arith.mulf"(%107, %32) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %117 = "arith.addf"(%115, %116) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %118 = "arith.mulf"(%113, %33) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %119 = "arith.addf"(%117, %118) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %120 = "arith.subf"(%119, %30) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
      %121 = "math.sqrt"(%120) <{fastmath = #arith.fastmath<none>}> : (f64) -> f64
      %122 = "tensor.insert"(%121, %arg2, %arg1) : (f64, tensor<10xf64>, index) -> tensor<10xf64>
      %123 = "tensor.from_elements"(%101, %107, %113) : (f64, f64, f64) -> tensor<3xf64>
      %124 = "tensor.insert_slice"(%123, %arg3, %arg1) <{operandSegmentSizes = array<i32: 1, 1, 1, 0, 0>, static_offsets = array<i64: -9223372036854775808, 0>, static_sizes = array<i64: 1, 3>, static_strides = array<i64: 1, 1>}> : (tensor<3xf64>, tensor<10x3xf64>, index) -> tensor<10x3xf64>
      %125 = "tensor.from_elements"(%36, %38, %40, %42, %45, %47, %49, %51, %54) : (f64, f64, f64, f64, f64, f64, f64, f64, f64) -> tensor<3x3xf64>
      %126 = "tensor.insert_slice"(%125, %arg4, %arg1) <{operandSegmentSizes = array<i32: 1, 1, 1, 0, 0>, static_offsets = array<i64: -9223372036854775808, 0, 0>, static_sizes = array<i64: 1, 3, 3>, static_strides = array<i64: 1, 1, 1>}> : (tensor<3x3xf64>, tensor<10x3x3xf64>, index) -> tensor<10x3x3xf64>
      "scf.yield"(%122, %124, %126) : (tensor<10xf64>, tensor<10x3xf64>, tensor<10x3x3xf64>) -> ()
    }) : (index, index, index, tensor<10xf64>, tensor<10x3xf64>, tensor<10x3x3xf64>) -> (tensor<10xf64>, tensor<10x3xf64>, tensor<10x3x3xf64>)
    "func.return"(%13#0, %13#1, %13#2) : (tensor<10xf64>, tensor<10x3xf64>, tensor<10x3x3xf64>) -> ()
  }) : () -> ()
}) : () -> ()

