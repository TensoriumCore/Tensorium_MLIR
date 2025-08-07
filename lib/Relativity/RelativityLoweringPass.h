#pragma once
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/Pass/Pass.h"

std::unique_ptr<mlir::Pass> createLowerRelativityPass();
