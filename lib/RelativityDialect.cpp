// lib/RelativityDialect.cpp
#include "Relativity/Dialect.h"

namespace mlir::relativity {
void RelativityDialect::initialize() {
  addOperations<
    #define GET_OP_LIST
    #include "Relativity/RelativityOps.h.inc"
  >();
}
} // namespace mlir::relativity namespace mlir::relativity
