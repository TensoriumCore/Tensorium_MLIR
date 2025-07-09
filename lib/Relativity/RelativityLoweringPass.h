#pragma once
#include "mlir/Pass/Pass.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/Pass/Pass.h"
std::unique_ptr<mlir::Pass> createLowerRelativityPass();
