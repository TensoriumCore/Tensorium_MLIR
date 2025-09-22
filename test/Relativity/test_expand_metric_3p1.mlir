"builtin.module"() ({
  "func.func"() <{function_type = (vector<4xf64>) -> tensor<3x3xf64>, sym_name = "SchwarzschildSpatial", sym_visibility = "public"}> ({
  ^bb0(%arg1: vector<4xf64>):
    %100 = "arith.constant"() <{value = 0 : index}> : () -> index
    %101 = "arith.constant"() <{value = -1.000000e+00 : f64}> : () -> f64
    %102 = "arith.constant"() <{value = 2.000000e+00 : f64}> : () -> f64
    %103 = "arith.constant"() <{value = 1.000000e-30 : f64}> : () -> f64
    %104 = "arith.constant"() <{value = 1.000000e+00 : f64}> : () -> f64
    %105 = "arith.constant"() <{value = 1 : index}> : () -> index
    %106 = "arith.constant"() <{value = 2 : index}> : () -> index
    %107 = "arith.constant"() <{value = 3 : index}> : () -> index
    %108 = "vector.extractelement"(%arg1, %105) : (vector<4xf64>, index) -> f64
    %109 = "vector.extractelement"(%arg1, %106) : (vector<4xf64>, index) -> f64
    %110 = "vector.extractelement"(%arg1, %107) : (vector<4xf64>, index) -> f64
    %111 = "arith.mulf"(%108, %108) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %112 = "arith.mulf"(%109, %109) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %113 = "arith.mulf"(%110, %110) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %114 = "arith.addf"(%111, %112) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %115 = "arith.addf"(%114, %113) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %116 = "arith.cmpf"(%115, %103) <{fastmath = #arith.fastmath<none>, predicate = 4 : i64}> : (f64, f64) -> i1
    %117 = "arith.select"(%116, %103, %115) : (i1, f64, f64) -> f64
    %118 = "math.sqrt"(%117) <{fastmath = #arith.fastmath<none>}> : (f64) -> f64
    %119 = "arith.divf"(%104, %118) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %120 = "arith.divf"(%108, %118) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %121 = "arith.divf"(%109, %118) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %122 = "arith.divf"(%110, %118) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %123 = "arith.mulf"(%119, %102) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %124 = "arith.addf"(%123, %101) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %125 = "arith.mulf"(%123, %120) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %126 = "arith.mulf"(%123, %121) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %127 = "arith.mulf"(%123, %122) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %128 = "arith.mulf"(%120, %120) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %129 = "arith.mulf"(%120, %121) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %130 = "arith.mulf"(%120, %122) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %131 = "arith.mulf"(%121, %121) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %132 = "arith.mulf"(%121, %122) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %133 = "arith.mulf"(%122, %122) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %134 = "arith.mulf"(%123, %128) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %135 = "arith.mulf"(%123, %129) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %136 = "arith.mulf"(%123, %130) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %137 = "arith.mulf"(%123, %131) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %138 = "arith.mulf"(%123, %132) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %139 = "arith.mulf"(%123, %133) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %140 = "arith.addf"(%134, %104) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %141 = "arith.addf"(%137, %104) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %142 = "arith.addf"(%139, %104) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %143 = "tensor.empty"() : () -> tensor<4x4xf64>
    %144 = "tensor.insert"(%124, %143, %100, %100) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %145 = "tensor.insert"(%125, %144, %100, %105) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %146 = "tensor.insert"(%126, %145, %100, %106) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %147 = "tensor.insert"(%127, %146, %100, %107) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %148 = "tensor.insert"(%125, %147, %105, %100) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %149 = "tensor.insert"(%140, %148, %105, %105) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %150 = "tensor.insert"(%135, %149, %105, %106) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %151 = "tensor.insert"(%136, %150, %105, %107) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %152 = "tensor.insert"(%126, %151, %106, %100) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %153 = "tensor.insert"(%135, %152, %106, %105) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %154 = "tensor.insert"(%141, %153, %106, %106) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %155 = "tensor.insert"(%138, %154, %106, %107) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %156 = "tensor.insert"(%127, %155, %107, %100) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %157 = "tensor.insert"(%136, %156, %107, %105) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %158 = "tensor.insert"(%138, %157, %107, %106) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %159 = "tensor.insert"(%142, %158, %107, %107) : (f64, tensor<4x4xf64>, index, index) -> tensor<4x4xf64>
    %160 = "tensor.extract_slice"(%159) <{operandSegmentSizes = array<i32: 1, 0, 0, 0>, static_offsets = array<i64: 1, 1>, static_sizes = array<i64: 3, 3>, static_strides = array<i64: 1, 1>}> : (tensor<4x4xf64>) -> tensor<3x3xf64>
    %161 = "relativity.metric.spatial"(%160) : (tensor<3x3xf64>) -> tensor<3x3xf64>
    "func.return"(%161) : (tensor<3x3xf64>) -> ()
  }) {llvm.emit_c_interface} : () -> ()
  "func.func"() <{function_type = (vector<4xf64>) -> (f64, tensor<3x3xf64>), sym_name = "DetInvGamma", sym_visibility = "public"}> ({
  ^bb0(%arg0: vector<4xf64>):
    %0 = "arith.constant"() <{value = 1.000000e-18 : f64}> : () -> f64
    %1 = "arith.constant"() <{value = 1.000000e+00 : f64}> : () -> f64
    %2 = "arith.constant"() <{value = 0.000000e+00 : f64}> : () -> f64
    %3 = "arith.constant"() <{value = 2 : index}> : () -> index
    %4 = "arith.constant"() <{value = 1 : index}> : () -> index
    %5 = "arith.constant"() <{value = 0 : index}> : () -> index
    %6 = "func.call"(%arg0) <{callee = @SchwarzschildSpatial}> : (vector<4xf64>) -> tensor<3x3xf64>
    %7 = "tensor.extract"(%6, %5, %5) : (tensor<3x3xf64>, index, index) -> f64
    %8 = "tensor.extract"(%6, %5, %4) : (tensor<3x3xf64>, index, index) -> f64
    %9 = "tensor.extract"(%6, %5, %3) : (tensor<3x3xf64>, index, index) -> f64
    %10 = "tensor.extract"(%6, %4, %4) : (tensor<3x3xf64>, index, index) -> f64
    %11 = "tensor.extract"(%6, %4, %3) : (tensor<3x3xf64>, index, index) -> f64
    %12 = "tensor.extract"(%6, %3, %4) : (tensor<3x3xf64>, index, index) -> f64
    %13 = "tensor.extract"(%6, %3, %3) : (tensor<3x3xf64>, index, index) -> f64
    %14 = "arith.mulf"(%10, %13) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %15 = "arith.mulf"(%11, %12) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %16 = "arith.subf"(%14, %15) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %17 = "arith.mulf"(%9, %12) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %18 = "arith.mulf"(%8, %13) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %19 = "arith.subf"(%17, %18) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %20 = "arith.mulf"(%8, %11) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %21 = "arith.mulf"(%9, %10) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %22 = "arith.subf"(%20, %21) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %23 = "arith.mulf"(%7, %16) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %24 = "arith.mulf"(%8, %19) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %25 = "arith.addf"(%23, %24) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %26 = "arith.mulf"(%9, %22) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %27 = "arith.addf"(%25, %26) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %28 = "tensor.extract"(%6, %5, %5) : (tensor<3x3xf64>, index, index) -> f64
    %29 = "tensor.extract"(%6, %5, %4) : (tensor<3x3xf64>, index, index) -> f64
    %30 = "tensor.extract"(%6, %5, %3) : (tensor<3x3xf64>, index, index) -> f64
    %31 = "tensor.extract"(%6, %4, %5) : (tensor<3x3xf64>, index, index) -> f64
    %32 = "tensor.extract"(%6, %4, %4) : (tensor<3x3xf64>, index, index) -> f64
    %33 = "tensor.extract"(%6, %4, %3) : (tensor<3x3xf64>, index, index) -> f64
    %34 = "tensor.extract"(%6, %3, %5) : (tensor<3x3xf64>, index, index) -> f64
    %35 = "tensor.extract"(%6, %3, %4) : (tensor<3x3xf64>, index, index) -> f64
    %36 = "tensor.extract"(%6, %3, %3) : (tensor<3x3xf64>, index, index) -> f64
    %37 = "arith.mulf"(%32, %36) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %38 = "arith.mulf"(%33, %35) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %39 = "arith.subf"(%37, %38) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %40 = "arith.mulf"(%31, %36) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %41 = "arith.mulf"(%33, %34) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %42 = "arith.subf"(%40, %41) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %43 = "arith.negf"(%42) <{fastmath = #arith.fastmath<none>}> : (f64) -> f64
    %44 = "arith.mulf"(%31, %35) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %45 = "arith.mulf"(%32, %34) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %46 = "arith.subf"(%44, %45) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %47 = "arith.mulf"(%29, %36) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %48 = "arith.mulf"(%30, %35) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %49 = "arith.subf"(%47, %48) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %50 = "arith.negf"(%49) <{fastmath = #arith.fastmath<none>}> : (f64) -> f64
    %51 = "arith.mulf"(%28, %36) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %52 = "arith.mulf"(%30, %34) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %53 = "arith.subf"(%51, %52) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %54 = "arith.mulf"(%28, %35) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %55 = "arith.mulf"(%29, %34) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %56 = "arith.subf"(%54, %55) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %57 = "arith.negf"(%56) <{fastmath = #arith.fastmath<none>}> : (f64) -> f64
    %58 = "arith.mulf"(%29, %33) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %59 = "arith.mulf"(%30, %32) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %60 = "arith.subf"(%58, %59) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %61 = "arith.mulf"(%28, %33) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %62 = "arith.mulf"(%30, %31) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %63 = "arith.subf"(%61, %62) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %64 = "arith.negf"(%63) <{fastmath = #arith.fastmath<none>}> : (f64) -> f64
    %65 = "arith.mulf"(%28, %32) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %66 = "arith.mulf"(%29, %31) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %67 = "arith.subf"(%65, %66) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %68 = "arith.mulf"(%28, %39) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %69 = "arith.mulf"(%29, %43) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %70 = "arith.addf"(%68, %69) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %71 = "arith.mulf"(%30, %46) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %72 = "arith.addf"(%70, %71) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %73 = "arith.cmpf"(%72, %2) <{fastmath = #arith.fastmath<none>, predicate = 4 : i64}> : (f64, f64) -> i1
    %74 = "arith.negf"(%72) <{fastmath = #arith.fastmath<none>}> : (f64) -> f64
    %75 = "arith.select"(%73, %74, %72) : (i1, f64, f64) -> f64
    %76 = "arith.cmpf"(%75, %0) <{fastmath = #arith.fastmath<none>, predicate = 3 : i64}> : (f64, f64) -> i1
    %77 = "arith.select"(%76, %75, %0) : (i1, f64, f64) -> f64
    %78 = "arith.divf"(%1, %77) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %79 = "arith.negf"(%78) <{fastmath = #arith.fastmath<none>}> : (f64) -> f64
    %80 = "arith.select"(%73, %79, %78) : (i1, f64, f64) -> f64
    %81 = "tensor.empty"() : () -> tensor<3x3xf64>
    %82 = "arith.mulf"(%39, %80) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %83 = "tensor.insert"(%82, %81, %5, %5) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %84 = "arith.mulf"(%50, %80) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %85 = "tensor.insert"(%84, %83, %5, %4) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %86 = "arith.mulf"(%60, %80) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %87 = "tensor.insert"(%86, %85, %5, %3) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %88 = "arith.mulf"(%43, %80) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %89 = "tensor.insert"(%88, %87, %4, %5) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %90 = "arith.mulf"(%53, %80) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %91 = "tensor.insert"(%90, %89, %4, %4) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %92 = "arith.mulf"(%64, %80) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %93 = "tensor.insert"(%92, %91, %4, %3) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %94 = "arith.mulf"(%46, %80) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %95 = "tensor.insert"(%94, %93, %3, %5) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %96 = "arith.mulf"(%57, %80) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %97 = "tensor.insert"(%96, %95, %3, %4) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    %98 = "arith.mulf"(%67, %80) <{fastmath = #arith.fastmath<none>}> : (f64, f64) -> f64
    %99 = "tensor.insert"(%98, %97, %3, %3) : (f64, tensor<3x3xf64>, index, index) -> tensor<3x3xf64>
    "func.return"(%27, %99) : (f64, tensor<3x3xf64>) -> ()
  }) {llvm.emit_c_interface} : () -> ()
}) : () -> ()

