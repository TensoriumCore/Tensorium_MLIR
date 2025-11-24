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

def MetricGetOp : Relativity_Op<"metric.get", [Pure]> {
  let summary = "Get ADM decomposition (Alpha, Beta, Gamma) for a metric";
  let description = [{
    Returns the 3+1 ADM variables for a given coordinate tensor.
    Outputs:
    - Alpha: Lapse (Scalar field)
    - Beta: Shift (Vector field)
    - Gamma: Spatial Metric (Tensor field)
  }];

  let hasVerifier = 1;
  let arguments = (ins StrAttr:$name, DictionaryAttr:$params, AnyRankedTensor:$x);

  let results = (outs AnyRankedTensor:$alpha, AnyRankedTensor:$beta, AnyRankedTensor:$gamma);

  let assemblyFormat = [{
    $name `params` `=` $params `(` $x `)` attr-dict `:` type($x) `->` `(` type($alpha) `,` type($beta) `,` type($gamma) `)`
  }];
}

def Relativity_SpatialMetricOp : Relativity_Op<"metric.spatial", [Pure]> {
  let summary = "Extract spatial 3×3 metric γ_ij from 4×4 g_{μν}";
  let description = [{
    Takes a 4×4 spacetime metric g_{μν} and returns the spatial block γ_ij,
    i.e. rows/cols 1..3 in 0-based indexing.
  }];
  // let hasVerifier = 1;

  let arguments = (ins RankedTensorOf<[F64]>:$g4);
  let results   = (outs RankedTensorOf<[F64]>:$gamma);

  let assemblyFormat = [{
    $g4 attr-dict `:` type($g4) `->` type($gamma)
  }];
}


def Rel_Det3x3Op : Op<Relativity_Dialect, "det3x3",
    [Pure]> {
  let summary = "determinant of a 3x3 matrix";
  let description = [{ Compute det(tensor<3x3xf64>) -> f64. }];
  let arguments = (ins TensorOf<[F64]>:$A);
  let results   = (outs F64:$det);
  let assemblyFormat = [{
    $A `:` type($A) `->` type($det) attr-dict
  }];
}

def Rel_Inv3x3Op : Op<Relativity_Dialect, "inv3x3",
    [Pure]> {
  let summary = "inverse of a 3x3 matrix";
  let description = [{
    Compute inverse of A in tensor<3x3xf64> using adj(A)/det(A).
    (No pivoting; caller must ensure det != 0.)
  }];
  let arguments = (ins TensorOf<[F64]>:$A);
  let results   = (outs TensorOf<[F64]>:$Ainv);
  let assemblyFormat = [{
    $A `:` type($A) `->` type($Ainv) attr-dict
  }];
}


#endif // RELATIVITY_OPS
