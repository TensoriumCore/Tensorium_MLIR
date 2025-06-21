#include "Relativity/RelativityDialect.h"
#include "Relativity/RelativityOps.h"

using namespace mlir;
using namespace mlir::relativity;

void RelativityDialect::initialize() {
  addOperations<
#define GET_OP_LIST
#include "Relativity/RelativityOps.cpp.inc"
      >();
}
