include "mlir/IR/OpBase.td"
include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/DialectBase.td"

def AddOp : Relativity_Op<"add", [Pure]> {
  let summary = "Addition";
  let description = [{
    Addition operation between two values.
  }];

  let arguments = (ins F64:$lhs, F64:$rhs);
  let results = (outs F64:$res);

  let hasCanonicalizer = 1;
  let hasFolder = 1;
}

