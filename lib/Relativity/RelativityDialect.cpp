
#include "Relativity/RelativityDialect.h"
#include "Relativity/RelativityOps.h"

#include "mlir/IR/DialectImplementation.h"

using namespace mlir;
using namespace mlir::relativity;

#include "Relativity/RelativityOpsDialect.cpp.inc"

void RelativityDialect::initialize() {
  addOperations<
#define GET_OP_LIST
#include "Relativity/RelativityOps.cpp.inc"
  >();
}

