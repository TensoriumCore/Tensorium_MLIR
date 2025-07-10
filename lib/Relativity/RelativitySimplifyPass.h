
#include "mlir/Pass/Pass.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/Pass/Pass.h"
#include "Utils/FormulaParser.h"

namespace mlir {
namespace relativity {

std::unique_ptr<mlir::Pass> createRelativitySimplifyPass();

} // namespace relativity
} // namespace mlir
