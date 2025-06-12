include "mlir/IR/OpBase.td"
include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/SymbolInterfaces.td"
include "mlir/IR/BuiltinAttributes.td"
include "mlir/Interfaces/SideEffectInterfaces.td"
include "mlir/Pass/PassBase.td"
include "RelativityDialect.td"


class Relativity_Dialect<string mnemonic> : Op<Relativity_Dialect, mnemonic>
{
  let summary = "Operation Class";
}

def RelativityTensor : TypeDef<Relativity_Dialect, "Tensor"> {
  let mnemonic = "tensor";
  let summary = "General relativity tensor type.";
  let description = [{
    Represents a tensor in general relativity computations.
  }];
}


