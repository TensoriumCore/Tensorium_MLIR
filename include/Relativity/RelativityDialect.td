include "mlir/IR/OpBase.td"

def Relativity_Dialect : Dialect {
  let name = "relativity";
  let summary = "Dialect for numerical relativity and BSSN formalism";
  let description = [{
    The Relativity dialect provides operations and types to model
    tensors, metrics, and geometric quantities arising in general relativity,
    especially for the 3+1 decomposition and BSSN formulation.
  }];
  let cppNamespace = "::mlir::relativity";
}

class Relativity_Op<string mnemonic, list<Trait> traits = []> :
  Op<Relativity_Dialect, mnemonic, traits>;
