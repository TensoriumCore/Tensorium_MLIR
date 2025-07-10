
#pragma once
#include "mlir/Pass/Pass.h"
#include "mlir/IR/BuiltinOps.h"

namespace mlir {
namespace relativity {
std::unique_ptr<mlir::Pass> createAssembleMetricTensorPass();
} // namespace relativity
} // namespace mlir

