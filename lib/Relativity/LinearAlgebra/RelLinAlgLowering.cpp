#include "Relativity/RelativityOps.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Tensor/IR/Tensor.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"

using namespace mlir;

static Value cidx(PatternRewriter &rw, Location loc, int64_t v) {
  return rw.create<arith::ConstantIndexOp>(loc, v);
}

static Value cfloat(PatternRewriter &rw, Location loc, double v,
                    FloatType fTy) {
  return rw.create<arith::ConstantFloatOp>(loc, llvm::APFloat(v), fTy);
}

static Value getA(PatternRewriter &rw, Location loc, Value A, int i, int j) {
  return rw.create<tensor::ExtractOp>(
      loc, A, ValueRange{cidx(rw, loc, i), cidx(rw, loc, j)});
}

namespace {
struct Det3x3Lower : OpRewritePattern<mlir::relativity::Det3x3Op> {
  using OpRewritePattern::OpRewritePattern;
  LogicalResult matchAndRewrite(mlir::relativity::Det3x3Op op,
                                PatternRewriter &rw) const override {
    Location loc = op.getLoc();
    Value A = op.getA();

    Value a00 = getA(rw, loc, A, 0, 0);
    Value a01 = getA(rw, loc, A, 0, 1);
    Value a02 = getA(rw, loc, A, 0, 2);
    Value a11 = getA(rw, loc, A, 1, 1);
    Value a12 = getA(rw, loc, A, 1, 2);
    Value a21 = getA(rw, loc, A, 2, 1);
    Value a22 = getA(rw, loc, A, 2, 2);

    auto mul = [&](Value x, Value y) {
      return rw.create<arith::MulFOp>(loc, x, y);
    };
    auto add = [&](Value x, Value y) {
      return rw.create<arith::AddFOp>(loc, x, y);
    };
    auto sub = [&](Value x, Value y) {
      return rw.create<arith::SubFOp>(loc, x, y);
    };

    Value C00 = sub(mul(a11, a22), mul(a12, a21));
    Value C01 = sub(mul(a02, a21), mul(a01, a22)); // = -(a01*a22 - a02*a21)
    Value C02 = sub(mul(a01, a12), mul(a02, a11));

    Value det = add(add(mul(a00, C00), mul(a01, C01)), mul(a02, C02));
    rw.replaceOp(op, det);
    return success();
  }
};

struct Inv3x3Lower : OpRewritePattern<mlir::relativity::Inv3x3Op> {
  using OpRewritePattern::OpRewritePattern;
  LogicalResult matchAndRewrite(mlir::relativity::Inv3x3Op op,
                                PatternRewriter &rw) const override {
    Location loc = op.getLoc();
    Value A = op.getA();

    auto outTy = dyn_cast<RankedTensorType>(op.getAinv().getType());
    if (!outTy || outTy.getRank() != 2 || outTy.getDimSize(0) != 3 ||
        outTy.getDimSize(1) != 3)
      return rw.notifyMatchFailure(op, "expect tensor<3x3xf64>");

    auto fTy = mlir::dyn_cast<FloatType>(outTy.getElementType());
    if (!fTy)
      return rw.notifyMatchFailure(op, "element type must be floating");

    Value a00 = getA(rw, loc, A, 0, 0);
    Value a01 = getA(rw, loc, A, 0, 1);
    Value a02 = getA(rw, loc, A, 0, 2);
    Value a10 = getA(rw, loc, A, 1, 0);
    Value a11 = getA(rw, loc, A, 1, 1);
    Value a12 = getA(rw, loc, A, 1, 2);
    Value a20 = getA(rw, loc, A, 2, 0);
    Value a21 = getA(rw, loc, A, 2, 1);
    Value a22 = getA(rw, loc, A, 2, 2);

    auto mul = [&](Value x, Value y) {
      return rw.create<arith::MulFOp>(loc, x, y);
    };
    auto add = [&](Value x, Value y) {
      return rw.create<arith::AddFOp>(loc, x, y);
    };
    auto sub = [&](Value x, Value y) {
      return rw.create<arith::SubFOp>(loc, x, y);
    };
    auto div = [&](Value x, Value y) {
      return rw.create<arith::DivFOp>(loc, x, y);
    };
    auto neg = [&](Value x) { return rw.create<arith::NegFOp>(loc, x); };

    Value C00 = sub(mul(a11, a22), mul(a12, a21));
    Value C01 = neg(sub(mul(a10, a22), mul(a12, a20)));
    Value C02 = sub(mul(a10, a21), mul(a11, a20));

    Value C10 = neg(sub(mul(a01, a22), mul(a02, a21)));
    Value C11 = sub(mul(a00, a22), mul(a02, a20));
    Value C12 = neg(sub(mul(a00, a21), mul(a01, a20)));

    Value C20 = sub(mul(a01, a12), mul(a02, a11));
    Value C21 = neg(sub(mul(a00, a12), mul(a02, a10)));
    Value C22 = sub(mul(a00, a11), mul(a01, a10));

    Value det = add(add(mul(a00, C00), mul(a01, C01)), mul(a02, C02));
    Value zero = cfloat(rw, loc, 0.0, fTy);
    Value one = cfloat(rw, loc, 1.0, fTy);
    Value eps = cfloat(rw, loc, 1e-18, fTy);

    Value isNeg =
        rw.create<arith::CmpFOp>(loc, arith::CmpFPredicate::OLT, det, zero);
    Value negdet = neg(det);
    Value absdet = rw.create<arith::SelectOp>(loc, isNeg, negdet, det);
    Value ge =
        rw.create<arith::CmpFOp>(loc, arith::CmpFPredicate::OGE, absdet, eps);
    Value use = rw.create<arith::SelectOp>(loc, ge, absdet, eps);

    Value invabs = div(one, use);
    Value invdet = rw.create<arith::SelectOp>(loc, isNeg, neg(invabs), invabs);

    Value T = rw.create<tensor::EmptyOp>(loc, ArrayRef<int64_t>{3, 3}, fTy);
    auto ins = [&](int i, int j, Value v) {
      T = rw.create<tensor::InsertOp>(
          loc, mul(v, invdet), T,
          ValueRange{cidx(rw, loc, i), cidx(rw, loc, j)});
    };

    ins(0, 0, C00);
    ins(0, 1, C10);
    ins(0, 2, C20);
    ins(1, 0, C01);
    ins(1, 1, C11);
    ins(1, 2, C21);
    ins(2, 0, C02);
    ins(2, 1, C12);
    ins(2, 2, C22);

    rw.replaceOp(op, T);
    return success();
  }
};

struct RelLinAlgLowerPass
    : PassWrapper<RelLinAlgLowerPass, OperationPass<ModuleOp>> {
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(RelLinAlgLowerPass)
  StringRef getArgument() const final { return "rel-linalg-lower"; }
  StringRef getDescription() const final {
    return "Lower det3x3/inv3x3 to arith/tensor";
  }
  void getDependentDialects(DialectRegistry &reg) const override {
    reg.insert<arith::ArithDialect, tensor::TensorDialect>();
  }
  void runOnOperation() override {
    RewritePatternSet ps(&getContext());
    ps.add<Det3x3Lower, Inv3x3Lower>(&getContext());
    GreedyRewriteConfig cfg;
    (void)applyPatternsGreedily(getOperation(), std::move(ps), cfg);
  }
};

} // namespace

namespace mlir::relativity {
std::unique_ptr<mlir::Pass> createRelLinAlgLowerPass() {
  return std::make_unique<::RelLinAlgLowerPass>();
}
} // namespace mlir::relativity
