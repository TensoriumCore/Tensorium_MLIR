#include "RelExpandMetricPass.h"
#include "Relativity/RelativityOps.h"

#include "llvm/Support/Casting.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/BuiltinOps.h"                  // ModuleOp
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"

#include "llvm/ADT/SmallVector.h"

using namespace mlir;
using namespace mlir::relativity;

namespace {

struct ExpandMetricGetPattern : mlir::OpRewritePattern<mlir::relativity::MetricGetOp> {
  using OpRewritePattern<mlir::relativity::MetricGetOp>::OpRewritePattern;

  mlir::LogicalResult matchAndRewrite(mlir::relativity::MetricGetOp op,
                                      mlir::PatternRewriter &rewriter) const override {
    auto nameAttr = op->getAttrOfType<mlir::StringAttr>("name");
    if (!nameAttr || nameAttr.getValue() != "minkowski")
      return mlir::failure();

	auto gTy = llvm::dyn_cast<mlir::RankedTensorType>(op.getG().getType());
    if (!gTy || gTy.getRank() != 2 || gTy.getShape()[0] != 4 ||
        gTy.getShape()[1] != 4 || !gTy.getElementType().isF64())
      return rewriter.notifyMatchFailure(op, "expected tensor<4x4xf64>");

    llvm::SmallVector<double, 16> vals = {
      -1.0, 0.0, 0.0, 0.0,
       0.0, 1.0, 0.0, 0.0,
       0.0, 0.0, 1.0, 0.0,
       0.0, 0.0, 0.0, 1.0
    };
    auto dense = mlir::DenseFPElementsAttr::get(gTy, llvm::ArrayRef<double>(vals));
    auto cst   = rewriter.create<mlir::arith::ConstantOp>(op.getLoc(), gTy, dense);
    rewriter.replaceOp(op, cst.getResult());
    return mlir::success();
  }
};

struct RelExpandMetricPass
    : mlir::PassWrapper<RelExpandMetricPass, mlir::OperationPass<mlir::ModuleOp>> {
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(RelExpandMetricPass)

  mlir::StringRef getArgument() const final { return "rel-expand-metric"; }
  mlir::StringRef getDescription() const final {
    return "Expand relativity.metric.get into arith ops (Minkowski)";
  }

  void runOnOperation() override {
    mlir::RewritePatternSet patterns(&getContext());
    patterns.add<ExpandMetricGetPattern>(&getContext());
    mlir::GreedyRewriteConfig cfg;
    (void)mlir::applyPatternsGreedily(getOperation(), std::move(patterns), cfg);
  }
};

} // namespace

std::unique_ptr<mlir::Pass> mlir::relativity::createRelExpandMetricPass() {
  return std::make_unique<RelExpandMetricPass>();
}
