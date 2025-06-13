
#include "Relativity/Dialect.h"

#define GET_TYPEDEF_DEFS
#include "Relativity/RelativityTypes.cpp.inc"

#include "Relativity/RelativityOps.h.inc"

#define GET_TYPEDEF_PARSER
#define GET_TYPEDEF_PRINTER
#include "Relativity/RelativityDialect.cpp.inc"

using namespace mlir;
using namespace mlir::relativity;


void RelativityDialect::initialize() {
#define GET_TYPEDEF_LIST
  addTypes<
#include "Relativity/RelativityTypes.h.inc"
  >();
#undef GET_TYPEDEF_LIST

#define GET_OP_LIST
  addOperations<
#include "Relativity/RelativityOps.cpp.inc"
  >();
#undef GET_OP_LIST
}
Type RelativityDialect::parseType(DialectAsmParser &parser) const {
    return Type();
}

void RelativityDialect::printType(Type type, DialectAsmPrinter &printer) const {
    
}
