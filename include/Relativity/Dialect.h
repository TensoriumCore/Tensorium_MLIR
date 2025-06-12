// include/Relativity/Dialect.h
#ifndef RELATIVITY_DIALECT_H
#define RELATIVITY_DIALECT_H

#include "mlir/IR/Dialect.h"

namespace mlir::relativity {
// Forward declaration (no class definition here)
class RelativityDialect;
} // namespace mlir::relativity

// Include the generated dialect header
#include "Relativity/RelativityDialect.h.inc"

// Additional declarations that aren't auto-generated can go here

#endif
