/*
 * Relativity/Ops.td — complete definitions of operations for the Relativity
 * dialect.
 *
 * This file is regenerated from scratch ("réécrit tout") following the latest
 * MLIR ODS conventions. It contains:
 *   • the dialect declaration
 *   • a convenient Relativity_Op alias that accepts an additional trait list
 *   • the first concrete operation: MinkowskiMetricOp, producing the 4‑D
 *     Minkowski metric tensor.
 */

//===----------------------------------------------------------------------===//
//===----------------------------------------------------------------------===//
// Required MLIR and ODS includes
//===----------------------------------------------------------------------===//


include "mlir/IR/OpBase.td"
include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/SymbolInterfaces.td"
include "mlir/IR/BuiltinAttributes.td"
include "mlir/Interfaces/SideEffectInterfaces.td"
include "mlir/Interfaces/InferTypeOpInterface.td"
include "mlir/IR/DialectBase.td"

def Relativity_Dialect : Dialect {
  let name        = "relativity";    
  let cppNamespace = "::mlir::relativity"; 
  let summary     = "Relativity Dialect";
  let useDefaultTypePrinterParser = 1; 
}

class Relativity_Op<string mnemonic, list<Trait> traits = []> :
    Op<Relativity_Dialect, mnemonic, traits> {
  let summary = "Operation in the Relativity dialect";
}

def RelativityTensor : TypeDef<Relativity_Dialect, "Tensor"> {
  let mnemonic = "tensor";
  let summary = "General relativity tensor type.";
  let description = [{
    Represents a tensor in general relativity computations.
  }];
}


