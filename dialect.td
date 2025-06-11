
include "mlir/IR/DialectBase.td"
include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/SymbolInterfaces.td"
include "mlir/IR/OpBase.td"
include "mlir/IR/BuiltinAttributes.td"

include "mlir/Pass/PassBase.td"

def MyDialect : Dialect {
    let summary = "A sample dialect for understanding";
    let name = "mydialect";
    let cppNamespace = "mlir::mydialect";
}


class MyDialectOp<string mnemonic> : Op<MyDialect, mnemonic>
{
  let summary = "Operation Class";
}

def MyDialect_Const : MyDialectOp<"const">
{
  let summary = "Returns a constant"; 
  let results = (outs I32:$result);
}

def convertmydialect2arith : Pass<"convert-mydialect-to-arith", "mlir::ModuleOp">{
    let summary = "Convert our dialect operations to arith dialect";
    let dependentDialects = ["mlir::mydialect::MyDialect"];
}

def MyDialect_Metric : MyDialectOp<"metric"> {
  let summary = "Symbolic 4x4 metric tensor g_{μν}";
  let description = [{
    This operation represents a symbolic 4×4 metric tensor `g_{μν}` with an optional name.
    It outputs a tensor value (could be `memref<4x4xf64>` or a symbolic type).
  }];
  
  let arguments = (ins StrAttr:$name);
  let results   = (outs AnyType:$g); // Remplace AnyType par un type concret si tu veux du concret (e.g. TensorOf<[4, 4], F64>)
  
  let assemblyFormat = "$name attr-dict `:` type($g)";
}

