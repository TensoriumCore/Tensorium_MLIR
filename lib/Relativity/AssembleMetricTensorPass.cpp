#include "Relativity/RelativityDialect.h"
#include "Relativity/RelativityOps.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Support/LogicalResult.h"

namespace mlir {
namespace relativity {
struct AssembleMetricTensorPass
    : public PassWrapper<AssembleMetricTensorPass,
                         OperationPass<mlir::ModuleOp>> {

  void runOnOperation() override {
    auto module = getOperation();

    std::vector<Value> components;

    for (auto func : module.getOps<mlir::func::FuncOp>()) {
      for (auto &block : func.getBody()) {
        for (auto &op : block) {
          if (auto metric =
                  llvm::dyn_cast<relativity::MetricComponentOp>(&op)) {
            components.push_back(metric.getResult());
          }
        }
      }
    }

    if (components.empty())
      return;

    auto funcIt = module.getOps<mlir::func::FuncOp>().begin();
    if (funcIt == module.getOps<mlir::func::FuncOp>().end())
      return;
    auto firstFunc = *funcIt;
    auto &entryBlock = firstFunc.getBody().front();
    auto terminator = entryBlock.getTerminator();

    OpBuilder b(terminator);
    auto tensorTy = RankedTensorType::get({4, 4}, b.getF64Type());
    auto tensorOp = b.create<relativity::MetricTensorOp>(module.getLoc(),
                                                         tensorTy, components);

    terminator->setOperand(0, tensorOp.getResult());
  }

  StringRef getArgument() const final { return "assemble-metric-tensor"; }
  StringRef getDescription() const final {
    return "Assembles full metric tensor from components";
  }
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(AssembleMetricTensorPass)
};

std::unique_ptr<mlir::Pass> createAssembleMetricTensorPass() {
  return std::make_unique<mlir::relativity::AssembleMetricTensorPass>();
}

} // namespace relativity
} // namespace mlir
