// RUN: relativity-opt %s --rel-linalg-lower -canonicalize --mlir-print-op-generic | FileCheck %s

module {
  func.func @ConstDetInv() {
    %A = arith.constant dense<[
      [1.0, 2.0, 3.0],
      [0.0, 1.0, 4.0],
      [5.0, 6.0, 0.0]
    ]> : tensor<3x3xf64>

    %d  = "relativity.det3x3"(%A) : (tensor<3x3xf64>) -> f64
    %Ai = "relativity.inv3x3"(%A) : (tensor<3x3xf64>) -> tensor<3x3xf64>
    func.return
  }
}

// det(A) = 1, et inv(A) contient -24, 18, 5, ...
// CHECK: "arith.constant"() <{value = 1.000000e+00 : f64}>
// CHECK: "arith.constant"() <{value = -2.400000e+01 : f64}>
// CHECK: "arith.constant"() <{value = 1.800000e+01 : f64}>
// CHECK: "arith.constant"() <{value = 5.000000e+00 : f64}>
