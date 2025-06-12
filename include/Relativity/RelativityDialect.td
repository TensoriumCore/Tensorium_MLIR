
// include/Relativity/RelativityDialect.td
include "mlir/IR/Dialect.td"
include "mlir/IR/OpBase.td"

def Relativity_Dialect : Dialect {
  let name = "relativity";
  let cppNamespace = "::mlir::relativity";
  let summary = "A dialect for relativistic computations";
  let description = [{

  }];
}
