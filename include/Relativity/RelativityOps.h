
#ifndef RELATIVITY_RELATIVITYOPS_H
#define RELATIVITY_RELATIVITYOPS_H

#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/OpDefinition.h"
#include "mlir/Interfaces/InferTypeOpInterface.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"

namespace mlir {
namespace relativity {

class CreateConformalMetricOp;

} // namespace relativity
} // namespace mlir

#define GET_OP_CLASSES
#include "Relativity/RelativityOps.h.inc"

#endif // RELATIVITY_RELATIVITYOPS_H

