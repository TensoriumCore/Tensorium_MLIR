/*===- TableGen'erated file -------------------------------------*- C++ -*-===*\
|*                                                                            *|
|* TypeDef Declarations                                                       *|
|*                                                                            *|
|* Automatically generated file, do not edit!                                 *|
|*                                                                            *|
\*===----------------------------------------------------------------------===*/

#ifdef GET_TYPEDEF_CLASSES
#undef GET_TYPEDEF_CLASSES


namespace mlir {
class AsmParser;
class AsmPrinter;
} // namespace mlir
namespace mlir {
namespace relativity {
/// General relativity tensor type.
/// Represents a tensor in general relativity computations.
class TensorType;
class TensorType : public ::mlir::Type::TypeBase<TensorType, ::mlir::Type, ::mlir::TypeStorage> {
public:
  using Base::Base;
  static constexpr ::llvm::StringLiteral name = "relativity.tensor";
  static constexpr ::llvm::StringLiteral dialectName = "relativity";
  static constexpr ::llvm::StringLiteral getMnemonic() {
    return {"tensor"};
  }

};
} // namespace relativity
} // namespace mlir
MLIR_DECLARE_EXPLICIT_TYPE_ID(::mlir::relativity::TensorType)

#endif  // GET_TYPEDEF_CLASSES

