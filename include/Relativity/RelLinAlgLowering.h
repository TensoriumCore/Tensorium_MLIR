#pragma once
#include "mlir/IR/BuiltinOps.h"
#include "mlir/Pass/Pass.h"

namespace mlir {
namespace relativity {
std::unique_ptr<mlir::Pass> createRelLinAlgLowerPass();
} // namespace relativity
} // namespace mlir
