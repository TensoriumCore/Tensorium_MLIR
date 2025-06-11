
// lib/RelativityDialect.cpp
#include "Relativity/Dialect.h"
#include "Relativity/RelativityDialect.h.inc"  // génération du dialecte lui-même

using namespace mlir;
using namespace mlir::relativity;

RelativityDialect::RelativityDialect(MLIRContext *ctx)
    : Dialect("relativity", ctx, TypeID::get<RelativityDialect>()) {
  initialize();
}

void RelativityDialect::initialize() {
  addOperations<
#define GET_OP_LIST
#include "Relativity/RelativityOps.cpp.inc"
  >();
}

