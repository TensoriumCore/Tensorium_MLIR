
#include "Relativity/RelativityOps.h"
#include "RelExtractSpatialPass.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Tensor/IR/Tensor.h"

#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"

using namespace mlir;

namespace {

static Value cidx(PatternRewriter &rewriter, Location loc, int64_t v) {
  return rewriter.create<arith::ConstantIndexOp>(loc, v);
}

struct LowerSpatialMetricPattern
    : OpRewritePattern<mlir::relativity::SpatialMetricOp> {
  using OpRewritePattern<mlir::relativity::SpatialMetricOp>::OpRewritePattern;

  LogicalResult matchAndRewrite(mlir::relativity::SpatialMetricOp op,
                                PatternRewriter &rewriter) const override {
    Location loc = op.getLoc();

    auto inTy  = dyn_cast<RankedTensorType>(op.getG4().getType());
    auto outTy = dyn_cast<RankedTensorType>(op.getGamma().getType());
    if (!inTy || inTy.getRank()!=2 || inTy.getDimSize(0)!=4 || inTy.getDimSize(1)!=4 ||
        !inTy.getElementType().isF64())
      return rewriter.notifyMatchFailure(op, "g4 must be tensor<4x4xf64>");
    if (!outTy || outTy.getRank()!=2 || outTy.getDimSize(0)!=3 || outTy.getDimSize(1)!=3 ||
        !outTy.getElementType().isF64())
      return rewriter.notifyMatchFailure(op, "gamma must be tensor<3x3xf64>");

    auto f64 = outTy.getElementType();
    Value T = rewriter.create<tensor::EmptyOp>(loc, ArrayRef<int64_t>{3,3}, f64);

    for (int64_t i = 0; i < 3; ++i) {
      for (int64_t j = 0; j < 3; ++j) {
        Value ii4 = cidx(rewriter, loc, i+1);
        Value jj4 = cidx(rewriter, loc, j+1);
        Value gij = rewriter.create<tensor::ExtractOp>(loc, op.getG4(), ValueRange{ii4, jj4});

        Value ii3 = cidx(rewriter, loc, i);
        Value jj3 = cidx(rewriter, loc, j);
        T = rewriter.create<tensor::InsertOp>(loc, gij, T, ValueRange{ii3, jj3});
      }
    }

    rewriter.replaceOp(op, T);
    return success();
  }
};

struct RelExtractSpatialPass
  : PassWrapper<RelExtractSpatialPass, OperationPass<ModuleOp>> {
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(RelExtractSpatialPass)
  StringRef getArgument() const final { return "rel-extract-spatial"; }
  StringRef getDescription() const final {
    return "Lower relativity.metric.spatial to tensor.extract/insert";
  }
  void getDependentDialects(DialectRegistry &registry) const override {
    registry.insert<arith::ArithDialect, tensor::TensorDialect>();
  }
  void runOnOperation() override {
    RewritePatternSet patterns(&getContext());
    patterns.add<LowerSpatialMetricPattern>(&getContext());
    GreedyRewriteConfig cfg;
    (void)applyPatternsGreedily(getOperation(), std::move(patterns), cfg);
  }
};

} // namespace

std::unique_ptr<mlir::Pass> mlir::relativity::createRelExtractSpatialPass() {
  return std::make_unique<RelExtractSpatialPass>();
}
