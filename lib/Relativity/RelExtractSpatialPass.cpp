#include "Relativity/RelExpandMetricPass.h"
#include "Relativity/RelativityOps.h"
#include "Relativity/RelExtractSpatialPass.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Linalg/IR/Linalg.h"
#include "mlir/Dialect/Tensor/IR/Tensor.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"

using namespace mlir;

namespace {
struct LowerSpatialMetricPattern
    : OpRewritePattern<mlir::relativity::SpatialMetricOp> {
  using OpRewritePattern<mlir::relativity::SpatialMetricOp>::OpRewritePattern;
  LogicalResult matchAndRewrite(mlir::relativity::SpatialMetricOp op,
                                PatternRewriter &rewriter) const override {
    Location loc = op.getLoc();

    Value g = op.getG4();
    auto inTy = dyn_cast<RankedTensorType>(g.getType());
    auto outTy = dyn_cast<RankedTensorType>(op.getType());

    if (!inTy || !outTy || !inTy.getElementType().isF64() ||
        !outTy.getElementType().isF64())
      return rewriter.notifyMatchFailure(op, "expected ranked f64 tensors");

    if (inTy.getRank() == 2 && inTy.getDimSize(0) == 3 &&
        inTy.getDimSize(1) == 3) {
      rewriter.replaceOp(op, g);
      return success();
    }

    if (inTy.getRank() == 2 && inTy.getDimSize(0) == 4 &&
        inTy.getDimSize(1) == 4 && outTy.getRank() == 2 &&
        outTy.getDimSize(0) == 3 && outTy.getDimSize(1) == 3) {
      SmallVector<OpFoldResult> offsets = {rewriter.getIndexAttr(1),
                                           rewriter.getIndexAttr(1)};
      SmallVector<OpFoldResult> sizes = {rewriter.getIndexAttr(3),
                                         rewriter.getIndexAttr(3)};
      SmallVector<OpFoldResult> strides = {rewriter.getIndexAttr(1),
                                           rewriter.getIndexAttr(1)};

      Value slice = rewriter.create<tensor::ExtractSliceOp>(loc, g, offsets,
                                                            sizes, strides);

      Value empty3 = rewriter.create<tensor::EmptyOp>(
          loc, ArrayRef<int64_t>{3, 3}, outTy.getElementType());
      auto copy = rewriter.create<linalg::CopyOp>(loc, slice, empty3);
      Value result = copy.getResult(0);

      if (result.getType() != outTy)
        result = rewriter.create<tensor::CastOp>(loc, outTy, result);

      rewriter.replaceOp(op, result);
      return success();
    }

    return rewriter.notifyMatchFailure(
        op, "unsupported shapes for relativity.metric.spatial");
  }
};

struct CompactExtracted3x3From4x4Pattern
    : OpRewritePattern<tensor::ExtractSliceOp> {
  using OpRewritePattern<tensor::ExtractSliceOp>::OpRewritePattern;

  LogicalResult matchAndRewrite(tensor::ExtractSliceOp op,
                                PatternRewriter &rewriter) const override {
    if (op->hasAttr("rel.compacted"))
      return failure();

    auto srcTy = dyn_cast<RankedTensorType>(op.getSource().getType());
    auto resTy = dyn_cast<RankedTensorType>(op.getType());

    if (!srcTy || !resTy)
      return failure();
    if (srcTy.getRank() != 2 || resTy.getRank() != 2)
      return failure();
    if (srcTy.getDimSize(0) != 4 || srcTy.getDimSize(1) != 4)
      return failure();
    if (resTy.getDimSize(0) != 3 || resTy.getDimSize(1) != 3)
      return failure();
    if (!srcTy.getElementType().isF64() || !resTy.getElementType().isF64())
      return failure();

    Location loc = op.getLoc();

    auto rebuilt = rewriter.create<tensor::ExtractSliceOp>(
        loc, resTy, op.getSource(), op.getMixedOffsets(), op.getMixedSizes(),
        op.getMixedStrides());
    rebuilt->setAttr("rel.compacted", rewriter.getUnitAttr());

    Value empty3 = rewriter.create<tensor::EmptyOp>(
        loc, ArrayRef<int64_t>{3, 3}, resTy.getElementType());

    auto copy =
        rewriter.create<linalg::CopyOp>(loc, rebuilt.getResult(), empty3);
    Value dense = copy.getResult(0);
		
    if (dense.getType() != resTy)
      dense = rewriter.create<tensor::CastOp>(loc, resTy, dense);

    rewriter.replaceOp(op, dense);
    return success();
  }
};
struct RelExtractSpatialPass
    : PassWrapper<RelExtractSpatialPass, OperationPass<ModuleOp>> {
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(RelExtractSpatialPass)

  StringRef getArgument() const final { return "rel-extract-spatial"; }

  StringRef getDescription() const final {
    return "Make 3x3 spatial metric tensors compact (via linalg.copy) whether "
           "coming from the custom op or from a 4x4 slice";
  }

  void getDependentDialects(DialectRegistry &registry) const override {
    registry.insert<arith::ArithDialect, tensor::TensorDialect,
                    linalg::LinalgDialect>();
  }

  void runOnOperation() override {
    RewritePatternSet patterns(&getContext());
    patterns.add<LowerSpatialMetricPattern>(&getContext());
    patterns.add<CompactExtracted3x3From4x4Pattern>(
        &getContext()); // <= crucial
    GreedyRewriteConfig cfg;
    (void)applyPatternsGreedily(getOperation(), std::move(patterns), cfg);
  }
};
} // namespace

std::unique_ptr<mlir::Pass> mlir::relativity::createRelExtractSpatialPass() {
  return std::make_unique<RelExtractSpatialPass>();
}
