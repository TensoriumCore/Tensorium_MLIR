#pragma once
#include "Utils/FormulaParser.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/Pass/Pass.h"

namespace mlir {
namespace relativity {
std::unique_ptr<mlir::Pass> createRelativitySimplifyPass();
} // namespace relativity
} // namespace mlir
