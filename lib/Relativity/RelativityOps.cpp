#include "Relativity/RelativityOps.h"
#include "Relativity/RelativityDialect.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/OpImplementation.h"
#include "llvm/Support/Casting.h"

using namespace mlir;
using namespace mlir::relativity;

LogicalResult CreateConformalMetricOp::verify() {
  llvm::errs() << "VERIFICATION CALLED!\n";
  auto type = getGammaIj().getType();
  auto tensorType = llvm::dyn_cast<RankedTensorType>(type);
  if (!tensorType || tensorType.getRank() != 2) {
    return emitOpError("gamma_ij must be a rank-2 tensor");
  }
  if (tensorType.getShape() != ArrayRef<int64_t>({3, 3})) {
    return emitOpError("gamma_ij must have shape 3x3");
  }
  llvm::errs() << "VERIFICATION PASSED!\n";
  return success();
}

void CreateConformalMetricOp::build(OpBuilder &builder, OperationState &state,
                                    Value gamma_ij, Value chi) {
  auto tensorType = llvm::cast<RankedTensorType>(gamma_ij.getType());
  state.addOperands({gamma_ij, chi});
  state.addTypes({tensorType});
}

static LogicalResult isVec4F64(Type ty) {
  if (auto vt = dyn_cast<VectorType>(ty))
    return (vt.getRank() == 1 && vt.getShape()[0] == 4 &&
            vt.getElementType().isF64())
               ? success()
               : failure();
  if (auto rt = dyn_cast<RankedTensorType>(ty))
    return (rt.getRank() == 1 && rt.getShape()[0] == 4 &&
            rt.getElementType().isF64())
               ? success()
               : failure();
  return failure();
}

LogicalResult MetricGetOp::verify() {
  if (failed(isVec4F64(getX().getType())))
    return emitOpError() << "expects x to be vector<4xf64> or tensor<4xf64>";

  auto gTy = dyn_cast<RankedTensorType>(getG().getType());
  if (!gTy || gTy.getRank() != 2 || gTy.getShape()[0] != 4 ||
      gTy.getShape()[1] != 4 || !gTy.getElementType().isF64())
    return emitOpError() << "expects result type tensor<4x4xf64>";

  return success();
}

#define GET_OP_CLASSES
#include "Relativity/RelativityOps.cpp.inc"
