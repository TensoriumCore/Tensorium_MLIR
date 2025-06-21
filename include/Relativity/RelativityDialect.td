#ifndef RELATIVITY_DIALECT
#define RELATIVITY_DIALECT

include "mlir/IR/OpBase.td"

def Relativity_Dialect : Dialect {
    let name = "relativity";
    let summary = "A relativity out-of-tree MLIR dialect.";
    let description = [{
        This dialect is an example of an out-of-tree MLIR dialect designed to
        illustrate the basic setup required to develop MLIR-based tools without
        working inside of the LLVM source tree.
    }];
    let cppNamespace = "::mlir::relativity";
}


class Relativity_Op<string mnemonic, list<Trait> traits = []> :
        Op<Relativity_Dialect, mnemonic, traits>;

#endif // RELATIVITY_DIALECT
