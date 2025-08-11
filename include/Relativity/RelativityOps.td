#ifndef RELATIVITY_OPS
#define RELATIVITY_OPS

include "RelativityDialect.td"
include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/DialectBase.td"
include "mlir/Interfaces/InferTypeOpInterface.td"
include "mlir/Interfaces/SideEffectInterfaces.td"
include "mlir/IR/OpBase.td"

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
  let builders = [
	  OpBuilder<(ins "Value":$gamma_ij, "Value":$chi)>
  ];
  let arguments = (ins TensorOf<[F64]>:$gamma_ij, F64:$chi);
  let results = (outs TensorOf<[F64]>:$conformal_gamma_ij);
  let assemblyFormat = [{
	  $gamma_ij `,` $chi `:` type($gamma_ij) `,` type($chi) `->` type($conformal_gamma_ij) attr-dict
  }];
}

def MetricComponentOp : Relativity_Op<"metric_component", [Pure]> {
  let summary = "A symbolic metric tensor component";
  let description = [{
    Symbolic operation representing a metric component, e.g., g_tt, g_rr, etc.
  }];
  let arguments = (ins Variadic<F64>:$vars);
  let results = (outs F64:$res);

  let assemblyFormat = [{
	  $vars attr-dict `:` type($vars) `->` type($res)
  }];

}

def MetricTensorOp : Relativity_Op<"metric_tensor", [Pure]> {
  let summary = "Assembles the full metric tensor from its components";
  let description = [{
    Constructs the full metric tensor $g_{ij}$ by assembling its individual components.
  }];
  let arguments = (ins Variadic<F64>:$components);
  let results = (outs TensorOf<[F64]>:$tensor);
  let assemblyFormat = [{
    $components attr-dict `:` type($components) `->` type($tensor)
  }];
}

def Relativity_MetricGetOp : Relativity_Op<"metric.get", [Pure]> {
  let summary = "Build g_{μν} for a named metric at a spacetime point";
  let hasVerifier = 1;     
  let hasCustomAssemblyFormat = 0;

  let arguments = (ins
    StrAttr:$name,
    DictionaryAttr:$params,
    AnyType:$x
  );
  let results = (outs RankedTensorOf<[F64]>:$g);
}


#endif // RELATIVITY_OPS
