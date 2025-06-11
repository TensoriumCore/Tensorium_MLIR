#include "Relativity/Dialect.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"

using namespace mlir;
using namespace mlir::relativity;

namespace {
struct SimplifyCommutativeDeriv : public OpRewritePattern<CovariantDerivativeOp> {
  using OpRewritePattern::OpRewritePattern;

  LogicalResult matchAndRewrite(CovariantDerivativeOp op, 
                               PatternRewriter &rewriter) const override {
    // TODO: Implémenter la commutation des dérivées
    return failure();
  }
};

struct RelativityOptPass : public PassWrapper<RelativityOptPass, OperationPass<>> {
  void runOnOperation() override {
    RewritePatternSet patterns(&getContext());
    patterns.add<SimplifyCommutativeDeriv>(&getContext());
    
    if (failed(applyPatternsAndFoldGreedily(getOperation(), std::move(patterns))))
      signalPassFailure();
  }
};
} // namespace

std::unique_ptr<Pass> mlir::relativity::createRelativityOptPass() {
  return std::make_unique<RelativityOptPass>();
}
