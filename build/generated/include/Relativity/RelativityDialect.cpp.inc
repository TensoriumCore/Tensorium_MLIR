/*===- TableGen'erated file -------------------------------------*- C++ -*-===*\
|*                                                                            *|
|* Dialect Definitions                                                        *|
|*                                                                            *|
|* Automatically generated file, do not edit!                                 *|
|* From: Ops.td                                                               *|
|*                                                                            *|
\*===----------------------------------------------------------------------===*/

MLIR_DEFINE_EXPLICIT_TYPE_ID(::mlir::relativity::RelativityDialect)
namespace mlir {
namespace relativity {

RelativityDialect::RelativityDialect(::mlir::MLIRContext *context)
    : ::mlir::Dialect(getDialectNamespace(), context, ::mlir::TypeID::get<RelativityDialect>())
    
     {
  
  initialize();
}

RelativityDialect::~RelativityDialect() = default;

} // namespace relativity
} // namespace mlir
