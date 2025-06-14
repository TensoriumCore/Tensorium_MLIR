include "mlir/IR/OpBase.td"
include "mlir/IR/DialectBase.td"
include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/BuiltinAttributes.td"
include "mlir/IR/SymbolInterfaces.td"
include "mlir/Interfaces/SideEffectInterfaces.td" 

def Relativity_Dialect : Dialect {
  let name = "relativity";
  let cppNamespace = "::mlir::relativity";
  let summary = "Relativity Dialect";
  let useDefaultTypePrinterParser = 1;
}

class Relativity_Op<string mnemonic, list<Trait> traits = []> :
    Op<Relativity_Dialect, mnemonic, traits> {
  let summary = "Operation in the Relativity dialect";
}
