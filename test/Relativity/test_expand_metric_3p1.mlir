"builtin.module"() ({
  "func.func"() <{function_type = (f64, f64, f64, f64) -> tensor<3x3xf64>, sym_name = "SchwarzschildSpatial"}> ({
  ^bb0(%arg4: f64, %arg5: f64, %arg6: f64, %arg7: f64):
    %103 = "arith.constant"() <{value = 0 : index}> : () -> index
    %104 = "arith.constant"() <{value = -1.000000e+00 : f64}> : () -> f64
    %105 = "arith.constant"() <{value = 2.000000e+00 : f64}> : () -> f64
    %106 = "arith.constant"() <{value = 1.000000e-30 : f64}> : () -> f64
    %107 = "arith.constant"() <{value = 3 : index}> : () -> index
    %108 = "arith.constant"() <{value = 2 : index}> : () -> index
    %109 = "arith.constant"() <{value = 1 : index}> : () -> index
    %110 = "arith.constant"() <{value = 1.000000e+00 : f64}> : () -> f64
    %111 = "vector.from_elements"(%arg4, %arg5, %arg6, %arg7) : (f64, f64, f64, f64) -> vector<4xf64>
    %112 = "vector.extractelement"(%111, %109) : (vector<4xf64>, index) -> f64
    %113 = "vector.extractelement"(%111, %108) : (vector<4xf64>, index) -> f64
    %114 = "vector.extractelement"(%111, %107) : (vector<4xf64>, index) -> f64
    %115 = "arith.mulf"(%112, %112) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %116 = "arith.mulf"(%113, %113) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %117 = "arith.mulf"(%114, %114) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %118 = "arith.addf"(%115, %116) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %119 = "arith.addf"(%118, %117) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %120 = "arith.cmpf"(%119, %106) <{fastmath = #arith.fastmath<none>, predicate = 4 : i64}> : (f64, f64) -> i1
    %121 = "arith.select"(%120, %106, %119) : (i1, f64, f64) -> f64
    %122 = "math.sqrt"(%121) <{fastmath = #arith.fastmath<none>}> : (f64) -> f64
    %123 = "arith.divf"(%110, %122) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %124 = "arith.divf"(%112, %122) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %125 = "arith.divf"(%113, %122) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %126 = "arith.divf"(%114, %122) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %127 = "arith.mulf"(%123, %105) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %128 = "arith.addf"(%127, %104) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %129 = "arith.mulf"(%127, %124) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %130 = "arith.mulf"(%127, %125) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %131 = "arith.mulf"(%127, %126) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %132 = "arith.mulf"(%124, %124) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %133 = "arith.mulf"(%124, %125) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %134 = "arith.mulf"(%124, %126) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %135 = "arith.mulf"(%125, %125) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %136 = "arith.mulf"(%125, %126) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %137 = "arith.mulf"(%126, %126) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %138 = "arith.mulf"(%127, %132) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %139 = "arith.mulf"(%127, %133) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %140 = "arith.mulf"(%127, %134) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %141 = "arith.mulf"(%127, %135) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %142 = "arith.mulf"(%127, %136) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %143 = "arith.mulf"(%127, %137) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %144 = "arith.addf"(%138, %110) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %145 = "arith.addf"(%141, %110) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %146 = "arith.addf"(%143, %110) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %147 = "tensor.empty"() : () -> tensor<4x4xf64>
    %148 = "tensor.insert"(%128, %147, %103, %103) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %149 = "tensor.insert"(%129, %148, %103, %109) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %150 = "tensor.insert"(%130, %149, %103, %108) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %151 = "tensor.insert"(%131, %150, %103, %107) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %152 = "tensor.insert"(%129, %151, %109, %103) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %153 = "tensor.insert"(%144, %152, %109, %109) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %154 = "tensor.insert"(%139, %153, %109, %108) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %155 = "tensor.insert"(%140, %154, %109, %107) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %156 = "tensor.insert"(%130, %155, %108, %103) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %157 = "tensor.insert"(%139, %156, %108, %109) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %158 = "tensor.insert"(%145, %157, %108, %108) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %159 = "tensor.insert"(%142, %158, %108, %107) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %160 = "tensor.insert"(%131, %159, %107, %103) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %161 = "tensor.insert"(%140, %160, %107, %109) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %162 = "tensor.insert"(%142, %161, %107, %108) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %163 = "tensor.insert"(%146, %162, %107, %107) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %164 = "tensor.extract_slice"(%163) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 1, 1>, static_sizes = array<i64: 3, 3>, static_strides = array<i64: 1, 1>}> {rel.compacted} : (tensor<4x4xf64>) -> tensor<3x3xf64>
    %165 = "tensor.empty"() : () -> tensor<3x3xf64>
    %166 = "linalg.copy"(%164, %165) <{operandSegmentSizes = array<i32: 1, 1>}> ({
    ^bb0(%arg8: f64, %arg9: f64):
      "linalg.yield"(%arg8) : (f64) -> ()
    }) : (tensor<3x3xf64>, tensor<3x3xf64>) -> tensor<3x3xf64>
    "func.return"(%166) : (tensor<3x3xf64>) -> ()
  }) : () -> ()
  "func.func"() <{function_type = (f64, f64, f64, f64) -> (f64, tensor<3x3xf64>), sym_name = "DetInvGamma"}> ({
  ^bb0(%arg0: f64, %arg1: f64, %arg2: f64, %arg3: f64):
    %0 = "arith.constant"() <{value = 1.000000e-18 : f64}> : () -> f64
    %1 = "arith.constant"() <{value = 1.000000e+00 : f64}> : () -> f64
    %2 = "arith.constant"() <{value = 0.000000e+00 : f64}> : () -> f64
    %3 = "arith.constant"() <{value = 2 : index}> : () -> index
    %4 = "arith.constant"() <{value = 1 : index}> : () -> index
    %5 = "arith.constant"() <{value = 0 : index}> : () -> index
    %6 = "func.call"(%arg0, %arg1, %arg2, %arg3) <{callee = @SchwarzschildSpatial}> : (f64, f64, f64, f64) -> tensor<3x3xf64>
    %7 = "tensor.extract"(%6, %5, %5) : (tensor<3x3xf64>, index, index) -> f64
    %8 = "tensor.extract"(%6, %5, %4) : (tensor<3x3xf64>, index, index) -> f64
    %9 = "tensor.extract"(%6, %5, %3) : (tensor<3x3xf64>, index, index) -> f64
    %10 = "tensor.extract"(%6, %4, %5) : (tensor<3x3xf64>, index, index) -> f64
    %11 = "tensor.extract"(%6, %4, %4) : (tensor<3x3xf64>, index, index) -> f64
    %12 = "tensor.extract"(%6, %4, %3) : (tensor<3x3xf64>, index, index) -> f64
    %13 = "tensor.extract"(%6, %3, %5) : (tensor<3x3xf64>, index, index) -> f64
    %14 = "tensor.extract"(%6, %3, %4) : (tensor<3x3xf64>, index, index) -> f64
    %15 = "tensor.extract"(%6, %3, %3) : (tensor<3x3xf64>, index, index) -> f64
    %16 = "arith.mulf"(%11, %15) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %17 = "arith.mulf"(%12, %14) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %18 = "arith.subf"(%16, %17) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %19 = "arith.mulf"(%10, %15) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %20 = "arith.mulf"(%12, %13) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %21 = "arith.subf"(%19, %20) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %22 = "arith.negf"(%21) <{fastmath = #arith.fastmath<none>}> : (f64) -> f64
    %23 = "arith.mulf"(%10, %14) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %24 = "arith.mulf"(%11, %13) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %25 = "arith.subf"(%23, %24) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %26 = "arith.mulf"(%7, %18) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %27 = "arith.mulf"(%8, %22) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %28 = "arith.addf"(%26, %27) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %29 = "arith.mulf"(%9, %25) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %30 = "arith.addf"(%28, %29) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %31 = "tensor.extract"(%6, %5, %5) : (tensor<3x3xf64>, index, index) -> f64
    %32 = "tensor.extract"(%6, %5, %4) : (tensor<3x3xf64>, index, index) -> f64
    %33 = "tensor.extract"(%6, %5, %3) : (tensor<3x3xf64>, index, index) -> f64
    %34 = "tensor.extract"(%6, %4, %5) : (tensor<3x3xf64>, index, index) -> f64
    %35 = "tensor.extract"(%6, %4, %4) : (tensor<3x3xf64>, index, index) -> f64
    %36 = "tensor.extract"(%6, %4, %3) : (tensor<3x3xf64>, index, index) -> f64
    %37 = "tensor.extract"(%6, %3, %5) : (tensor<3x3xf64>, index, index) -> f64
    %38 = "tensor.extract"(%6, %3, %4) : (tensor<3x3xf64>, index, index) -> f64
    %39 = "tensor.extract"(%6, %3, %3) : (tensor<3x3xf64>, index, index) -> f64
    %40 = "arith.mulf"(%35, %39) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %41 = "arith.mulf"(%36, %38) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %42 = "arith.subf"(%40, %41) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %43 = "arith.mulf"(%34, %39) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %44 = "arith.mulf"(%36, %37) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %45 = "arith.subf"(%43, %44) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %46 = "arith.negf"(%45) <{fastmath = #arith.fastmath<none>}> : (f64) -> f64
    %47 = "arith.mulf"(%34, %38) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %48 = "arith.mulf"(%35, %37) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %49 = "arith.subf"(%47, %48) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %50 = "arith.mulf"(%32, %39) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %51 = "arith.mulf"(%33, %38) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %52 = "arith.subf"(%50, %51) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %53 = "arith.negf"(%52) <{fastmath = #arith.fastmath<none>}> : (f64) -> f64
    %54 = "arith.mulf"(%31, %39) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %55 = "arith.mulf"(%33, %37) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %56 = "arith.subf"(%54, %55) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %57 = "arith.mulf"(%31, %38) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %58 = "arith.mulf"(%32, %37) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %59 = "arith.subf"(%57, %58) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %60 = "arith.negf"(%59) <{fastmath = #arith.fastmath<none>}> : (f64) -> f64
    %61 = "arith.mulf"(%32, %36) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %62 = "arith.mulf"(%33, %35) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %63 = "arith.subf"(%61, %62) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %64 = "arith.mulf"(%31, %36) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %65 = "arith.mulf"(%33, %34) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %66 = "arith.subf"(%64, %65) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %67 = "arith.negf"(%66) <{fastmath = #arith.fastmath<none>}> : (f64) -> f64
    %68 = "arith.mulf"(%31, %35) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %69 = "arith.mulf"(%32, %34) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %70 = "arith.subf"(%68, %69) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %71 = "arith.mulf"(%31, %42) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %72 = "arith.mulf"(%32, %46) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %73 = "arith.addf"(%71, %72) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %74 = "arith.mulf"(%33, %49) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %75 = "arith.addf"(%73, %74) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %76 = "arith.cmpf"(%75, %2) <{fastmath = #arith.fastmath<none>, predicate = 4 : i64}> : (f64, f64) -> i1
    %77 = "arith.negf"(%75) <{fastmath = #arith.fastmath<none>}> : (f64) -> f64
    %78 = "arith.select"(%76, %77, %75) : (i1, f64, f64) -> f64
    %79 = "arith.cmpf"(%78, %0) <{fastmath = #arith.fastmath<none>, predicate = 3 : i64}> : (f64, f64) -> i1
    %80 = "arith.select"(%79, %78, %0) : (i1, f64, f64) -> f64
    %81 = "arith.divf"(%1, %80) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %82 = "arith.negf"(%81) <{fastmath = #arith.fastmath<none>}> : (f64) -> f64
    %83 = "arith.select"(%76, %82, %81) : (i1, f64, f64) -> f64
    %84 = "tensor.empty"() : () -> tensor<3x3xf64>
    %85 = "arith.mulf"(%42, %83) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %86 = "tensor.insert"(%85, %84, %5, %5) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %87 = "arith.mulf"(%53, %83) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %88 = "tensor.insert"(%87, %86, %5, %4) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %89 = "arith.mulf"(%63, %83) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %90 = "tensor.insert"(%89, %88, %5, %3) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %91 = "arith.mulf"(%46, %83) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %92 = "tensor.insert"(%91, %90, %4, %5) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %93 = "arith.mulf"(%56, %83) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %94 = "tensor.insert"(%93, %92, %4, %4) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %95 = "arith.mulf"(%67, %83) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %96 = "tensor.insert"(%95, %94, %4, %3) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %97 = "arith.mulf"(%49, %83) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %98 = "tensor.insert"(%97, %96, %3, %5) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %99 = "arith.mulf"(%60, %83) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %100 = "tensor.insert"(%99, %98, %3, %4) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %101 = "arith.mulf"(%70, %83) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %102 = "tensor.insert"(%101, %100, %3, %3) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    "func.return"(%30, %102) : (f64, tensor<3x3xf64>) -> ()
  }) : () -> ()
}) : () -> ()

