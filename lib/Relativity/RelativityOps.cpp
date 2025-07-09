#include "Relativity/RelativityOps.h"
#include "Relativity/RelativityDialect.h"
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

void CreateConformalMetricOp::build(OpBuilder &builder,
                                    OperationState &state,
                                    Value gamma_ij, Value chi) {
  auto tensorType = llvm::cast<RankedTensorType>(gamma_ij.getType());
  state.addOperands({gamma_ij, chi});
  state.addTypes({tensorType});
}

#define GET_OP_CLASSES
#include "Relativity/RelativityOps.cpp.inc"
