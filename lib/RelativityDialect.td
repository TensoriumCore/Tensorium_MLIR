
include "mlir/IR/OpBase.td"
include "mlir/IR/DialectBase.td"

def Relativity_Dialect : Dialect {
  let name = "relativity";
  let cppNamespace = "::mlir::relativity";
  let description = [{
    Dialect for numerical relativity computations.
  }];
}

