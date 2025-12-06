
#ifndef RELATIVITY_LOWERING_PASS_H
#define RELATIVITY_LOWERING_PASS_H

#include "mlir/Pass/Pass.h"

namespace mlir {
namespace relativity {

std::unique_ptr<mlir::Pass> createLowerRelativityPass();

} // namespace relativity
} // namespace mlir

#endif // RELATIVITY_LOWERING_PASS_H

