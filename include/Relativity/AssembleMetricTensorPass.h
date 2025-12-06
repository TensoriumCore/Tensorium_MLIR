#pragma once
#include "mlir/IR/BuiltinOps.h"
#include "mlir/Pass/Pass.h"

namespace mlir {
namespace relativity {
std::unique_ptr<mlir::Pass> createAssembleMetricTensorPass();
} // namespace relativity
} // namespace mlir
