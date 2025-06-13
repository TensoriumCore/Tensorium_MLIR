#ifndef RELATIVITY_OPS_H
#define RELATIVITY_OPS_H

#include "Relativity/Dialect.h"
#include "mlir/IR/OpDefinition.h"
#include "mlir/Interfaces/InferTypeOpInterface.h"


// Ensuite les opérations générées
#define GET_OP_CLASSES
#include "Relativity/RelativityOps.h.inc"

#endif
