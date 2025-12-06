#pragma once
#include "mlir/Pass/Pass.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"

namespace mlir {
namespace relativity {

std::unique_ptr<Pass> createRelAddCInterfacePass();
void registerRelAddCInterfacePass();

} // namespace relativity
} // namespace mlir
