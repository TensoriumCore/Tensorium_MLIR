#include "Relativity/RelativityOps.h"
#include "Relativity/RelativityDialect.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/OpImplementation.h"
#include "mlir/IR/TypeUtilities.h"
#include "llvm/Support/Casting.h"

using namespace mlir;
using namespace mlir::relativity;


LogicalResult CreateConformalMetricOp::verify() {
  auto type = getGammaIj().getType();
  auto tensorType = llvm::dyn_cast<RankedTensorType>(type);
  if (!tensorType || tensorType.getRank() != 2) {
    return emitOpError("gamma_ij must be a rank-2 tensor");
  }
  if (tensorType.getShape() != ArrayRef<int64_t>({3, 3})) {
    return emitOpError("gamma_ij must have shape 3x3");
  }
  return success();
}

void CreateConformalMetricOp::build(OpBuilder &builder, OperationState &state,
                                    Value gamma_ij, Value chi) {
  auto tensorType = llvm::cast<RankedTensorType>(gamma_ij.getType());
  state.addOperands({gamma_ij, chi});
  state.addTypes({tensorType});
}

mlir::LogicalResult MetricGetOp::verify() {
  auto inputType = llvm::cast<RankedTensorType>(getX().getType());
  auto alphaType = llvm::cast<RankedTensorType>(getAlpha().getType());
  auto betaType = llvm::cast<RankedTensorType>(getBeta().getType());
  auto gammaType = llvm::cast<RankedTensorType>(getGamma().getType());

  ArrayRef<int64_t> inShape = inputType.getShape();
  if (inShape.size() < 1 || inShape.back() != 4)
    return emitOpError("input last dim must be 4");

  ArrayRef<int64_t> gridShape = inShape.drop_back();
  if (alphaType.getShape() != gridShape)
    return emitOpError("alpha output shape mismatch");

  SmallVector<int64_t> expectedBeta(gridShape.begin(), gridShape.end());
  expectedBeta.push_back(3);
  if (betaType.getShape() != ArrayRef<int64_t>(expectedBeta))
    return emitOpError("beta output shape mismatch");

  SmallVector<int64_t> expectedGamma(gridShape.begin(), gridShape.end());
  expectedGamma.push_back(3);
  expectedGamma.push_back(3);
  if (gammaType.getShape() != ArrayRef<int64_t>(expectedGamma))
    return emitOpError("gamma output shape mismatch");

  return mlir::success();
}

#define GET_OP_CLASSES
#include "Relativity/RelativityOps.cpp.inc"
