
// RelativityDialect.cpp

#include "Relativity/Dialect.h"
#include "Relativity/RelativityOps.h"

using namespace mlir;
using namespace mlir::relativity;

RelativityDialect::RelativityDialect(MLIRContext *ctx)
    : Dialect("relativity", ctx, TypeID::get<RelativityDialect>()) {
  addOperations<
#define GET_OP_LIST
#include "Relativity/RelativityOps.cpp.inc"
      >();
}

