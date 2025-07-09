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

def CreateConformalMetricOp : Relativity_Op<"create_conformal_metric", [Pure]> {
  let summary = "Compute conformal 3-metric γ̃_ij = χ * γ_ij";
  let description = [{
    This operation scales the physical 3-metric γ_ij by the conformal factor χ
    to compute the conformal 3-metric γ̃_ij.
  }];

  let hasVerifier = 1;
  let hasCustomAssemblyFormat = 1;
  let builders = [
	  OpBuilder<(ins "Value":$gamma_ij, "Value":$chi)>
  ];
  let arguments = (ins TensorOf<[F64]>:$gamma_ij, F64:$chi);
  let results = (outs TensorOf<[F64]>:$conformal_gamma_ij);
  let assemblyFormat = [{
	  $gamma_ij `,` $chi `:` type($gamma_ij) `,` type($chi) `->` type($conformal_gamma_ij) attr-dict
  }];
}
#endif // RELATIVITY_OPS
