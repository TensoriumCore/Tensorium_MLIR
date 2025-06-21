#ifndef RELATIVITY_OPS
#define RELATIVITY_OPS

include "RelativityDialect.td"
include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/DialectBase.td"
include "mlir/Interfaces/InferTypeOpInterface.td"
include "mlir/Interfaces/SideEffectInterfaces.td"

def Relativity_FooOp : Relativity_Op<"foo", [Pure,
                                             SameOperandsAndResultType]> {
    let summary = "Illustrates how to define an operation.";
    let description = [{
        The `relativity.foo` operation illustrates how to define a new
        operation in a dialect. It uses an operation trait to declare that it
        has no side effects.
	}];

    let arguments = (ins I32:$input);
    let results = (outs I32:$res);

    let assemblyFormat = [{
        $input attr-dict `:` type($input)
    }];
}


def AddOp : Relativity_Op<"add", [Pure]> {
  let summary = "Addition";
  let description = [{
    Addition operation between two values.
  }];

  let arguments = (ins F64:$lhs, F64:$rhs);
  let results = (outs F64:$res);

  let assemblyFormat = [{
    $lhs `,` $rhs `:` type($lhs) attr-dict
  }];
}

#endif // RELATIVITY_OPS
