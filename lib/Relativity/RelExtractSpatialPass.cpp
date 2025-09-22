
#include "RelExtractSpatialPass.h"
#include "Relativity/RelativityOps.h"
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
    auto outTy = dyn_cast<RankedTensorType>(op.getType()); 

    if (!inTy || inTy.getRank() != 2 || inTy.getDimSize(0) != 4 ||
        inTy.getDimSize(1) != 4 || !inTy.getElementType().isF64())
      return rewriter.notifyMatchFailure(op, "g4 must be tensor<4x4xf64>");
    if (!outTy || outTy.getRank() != 2 || outTy.getDimSize(0) != 3 ||
        outTy.getDimSize(1) != 3 || !outTy.getElementType().isF64())
      return rewriter.notifyMatchFailure(op, "result must be tensor<3x3xf64>");
    SmallVector<OpFoldResult> offsets = {
        rewriter.getIndexAttr(1), rewriter.getIndexAttr(1)};
    SmallVector<OpFoldResult> sizes = {
        rewriter.getIndexAttr(3), rewriter.getIndexAttr(3)};
    SmallVector<OpFoldResult> strides = {
        rewriter.getIndexAttr(1), rewriter.getIndexAttr(1)};

    Value slice = rewriter.create<tensor::ExtractSliceOp>(
        loc, op.getG4(), offsets, sizes, strides);

    if (slice.getType() != outTy)
      slice = rewriter.create<tensor::CastOp>(loc, outTy, slice);

    rewriter.replaceOp(op, slice);
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
