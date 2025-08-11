#include "RelExpandMetricPass.h"
#include "Relativity/RelativityOps.h"
#include "Relativity/RelativityOps.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Math/IR/Math.h"
#include "mlir/Dialect/Tensor/IR/Tensor.h"
#include "mlir/Dialect/Vector/IR/VectorOps.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/BuiltinOps.h"       // ModuleOp
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"

#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/Casting.h"

using namespace mlir;
using namespace mlir::relativity;

namespace {

struct ExpandMetricGetPattern
    : mlir::OpRewritePattern<mlir::relativity::MetricGetOp> {
  using OpRewritePattern<mlir::relativity::MetricGetOp>::OpRewritePattern;

  ExpandMetricGetPattern(mlir::MLIRContext *ctx)
      : OpRewritePattern<mlir::relativity::MetricGetOp>(ctx) {}

  mlir::LogicalResult matchAndRewrite(mlir::relativity::MetricGetOp op,
                                      mlir::PatternRewriter &rewriter) const override {
    auto nameAttr = op->getAttrOfType<mlir::StringAttr>("name");
    if (!nameAttr)
      return mlir::failure();

    if (nameAttr.getValue() == "minkowski") {
      auto gTy = llvm::dyn_cast<mlir::RankedTensorType>(op.getG().getType());
      if (!gTy || gTy.getRank() != 2 || gTy.getShape()[0] != 4 ||
          gTy.getShape()[1] != 4 || !gTy.getElementType().isF64())
        return rewriter.notifyMatchFailure(op, "expected tensor<4x4xf64>");

      llvm::SmallVector<double, 16> vals = {
          -1.0, 0.0, 0.0, 0.0,
           0.0, 1.0, 0.0, 0.0,
           0.0, 0.0, 1.0, 0.0,
           0.0, 0.0, 0.0, 1.0};
      auto dense = mlir::DenseFPElementsAttr::get(gTy, llvm::ArrayRef<double>(vals));
      auto cst   = rewriter.create<mlir::arith::ConstantOp>(op.getLoc(), gTy, dense);
      rewriter.replaceOp(op, cst.getResult());
      return mlir::success();
    }

    if (nameAttr.getValue() != "schwarzschild_ks")
      return mlir::failure();

    auto gTy = llvm::dyn_cast<mlir::RankedTensorType>(op.getG().getType());
    if (!gTy || gTy.getRank() != 2 || gTy.getShape()[0] != 4 ||
        gTy.getShape()[1] != 4 || !gTy.getElementType().isF64())
      return rewriter.notifyMatchFailure(op, "expected g : tensor<4x4xf64>");

    double Mdef = 1.0;
    if (auto dict = op->getAttrOfType<mlir::DictionaryAttr>("params")) {
      if (auto any = dict.get("M")) {
        if (auto Ma = llvm::dyn_cast<mlir::FloatAttr>(any))
          Mdef = Ma.getValueAsDouble();
      }
    }

    auto f64 = rewriter.getF64Type();
    auto cstM = rewriter.create<mlir::arith::ConstantFloatOp>(op.getLoc(),
                                                              llvm::APFloat(Mdef), f64);

    // x = (t,x,y,z)
    auto i0 = rewriter.create<mlir::arith::ConstantIndexOp>(op.getLoc(), 0);
    auto i1 = rewriter.create<mlir::arith::ConstantIndexOp>(op.getLoc(), 1);
    auto i2 = rewriter.create<mlir::arith::ConstantIndexOp>(op.getLoc(), 2);
    auto i3 = rewriter.create<mlir::arith::ConstantIndexOp>(op.getLoc(), 3);

    auto t = rewriter.create<mlir::vector::ExtractElementOp>(op.getLoc(), op.getX(), i0);
    auto x = rewriter.create<mlir::vector::ExtractElementOp>(op.getLoc(), op.getX(), i1);
    auto y = rewriter.create<mlir::vector::ExtractElementOp>(op.getLoc(), op.getX(), i2);
    auto z = rewriter.create<mlir::vector::ExtractElementOp>(op.getLoc(), op.getX(), i3);
    (void)t; 

    // r = sqrt(x^2+y^2+z^2)
    auto x2 = rewriter.create<mlir::arith::MulFOp>(op.getLoc(), x, x);
    auto y2 = rewriter.create<mlir::arith::MulFOp>(op.getLoc(), y, y);
    auto z2 = rewriter.create<mlir::arith::MulFOp>(op.getLoc(), z, z);
    auto s1 = rewriter.create<mlir::arith::AddFOp>(op.getLoc(), x2, y2);
    auto s2 = rewriter.create<mlir::arith::AddFOp>(op.getLoc(), s1, z2);
    auto r  = rewriter.create<mlir::math::SqrtOp>(op.getLoc(), s2);

    // H = M / r
    auto H  = rewriter.create<mlir::arith::DivFOp>(op.getLoc(), cstM, r);

    // l_mu = (1, x/r, y/r, z/r)
    auto one = rewriter.create<mlir::arith::ConstantFloatOp>(op.getLoc(), llvm::APFloat(1.0), f64);
    auto lx  = rewriter.create<mlir::arith::DivFOp>(op.getLoc(), x, r);
    auto ly  = rewriter.create<mlir::arith::DivFOp>(op.getLoc(), y, r);
    auto lz  = rewriter.create<mlir::arith::DivFOp>(op.getLoc(), z, r);

    // 2H
    auto c2   = rewriter.create<mlir::arith::ConstantFloatOp>(op.getLoc(), llvm::APFloat(2.0), f64);
    auto twoH = rewriter.create<mlir::arith::MulFOp>(op.getLoc(), c2, H);

    // g00 = -1 + 2H
    auto minus1 = rewriter.create<mlir::arith::ConstantFloatOp>(op.getLoc(), llvm::APFloat(-1.0), f64);
    auto g00 = rewriter.create<mlir::arith::AddFOp>(op.getLoc(), minus1, twoH);

    // g0i = 2H * l_i
    auto g01 = rewriter.create<mlir::arith::MulFOp>(op.getLoc(), twoH, lx);
    auto g02 = rewriter.create<mlir::arith::MulFOp>(op.getLoc(), twoH, ly);
    auto g03 = rewriter.create<mlir::arith::MulFOp>(op.getLoc(), twoH, lz);

    // gij = δij + 2H * l_i * l_j
    auto lx_lx = rewriter.create<mlir::arith::MulFOp>(op.getLoc(), lx, lx);
    auto lx_ly = rewriter.create<mlir::arith::MulFOp>(op.getLoc(), lx, ly);
    auto lx_lz = rewriter.create<mlir::arith::MulFOp>(op.getLoc(), lx, lz);
    auto ly_ly = rewriter.create<mlir::arith::MulFOp>(op.getLoc(), ly, ly);
    auto ly_lz = rewriter.create<mlir::arith::MulFOp>(op.getLoc(), ly, lz);
    auto lz_lz = rewriter.create<mlir::arith::MulFOp>(op.getLoc(), lz, lz);

    auto twoH_lx_lx = rewriter.create<mlir::arith::MulFOp>(op.getLoc(), twoH, lx_lx);
    auto twoH_lx_ly = rewriter.create<mlir::arith::MulFOp>(op.getLoc(), twoH, lx_ly);
    auto twoH_lx_lz = rewriter.create<mlir::arith::MulFOp>(op.getLoc(), twoH, lx_lz);
    auto twoH_ly_ly = rewriter.create<mlir::arith::MulFOp>(op.getLoc(), twoH, ly_ly);
    auto twoH_ly_lz = rewriter.create<mlir::arith::MulFOp>(op.getLoc(), twoH, ly_lz);
    auto twoH_lz_lz = rewriter.create<mlir::arith::MulFOp>(op.getLoc(), twoH, lz_lz);

    auto g11 = rewriter.create<mlir::arith::AddFOp>(op.getLoc(), one, twoH_lx_lx);
    auto g22 = rewriter.create<mlir::arith::AddFOp>(op.getLoc(), one, twoH_ly_ly);
    auto g33 = rewriter.create<mlir::arith::AddFOp>(op.getLoc(), one, twoH_lz_lz);

    auto g12 = twoH_lx_ly;
    auto g13 = twoH_lx_lz;
    auto g23 = twoH_ly_lz;

    // tensor<4x4xf64> via tensor.empty + tensor.insert
    auto c0  = rewriter.create<mlir::arith::ConstantIndexOp>(op.getLoc(), 0);
    auto c1  = rewriter.create<mlir::arith::ConstantIndexOp>(op.getLoc(), 1);
    auto c2i = rewriter.create<mlir::arith::ConstantIndexOp>(op.getLoc(), 2);
    auto c3  = rewriter.create<mlir::arith::ConstantIndexOp>(op.getLoc(), 3);

    auto empty = rewriter.create<mlir::tensor::EmptyOp>(op.getLoc(),
                          mlir::ArrayRef<int64_t>{4, 4}, f64);

    auto ins = [&](mlir::Value tensor, mlir::Value v, mlir::Value i, mlir::Value j) {
      return rewriter.create<mlir::tensor::InsertOp>(op.getLoc(), v, tensor,
                                                     mlir::ValueRange{i, j});
    };

    mlir::Value T = empty.getResult();
    T = ins(T, g00, c0, c0);
    T = ins(T, g01, c0, c1);
    T = ins(T, g02, c0, c2i);
    T = ins(T, g03, c0, c3);

    T = ins(T, g01, c1, c0);
    T = ins(T, g11, c1, c1);
    T = ins(T, g12, c1, c2i);
    T = ins(T, g13, c1, c3);

    T = ins(T, g02, c2i, c0);
    T = ins(T, g12, c2i, c1);
    T = ins(T, g22, c2i, c2i);
    T = ins(T, g23, c2i, c3);

    T = ins(T, g03, c3, c0);
    T = ins(T, g13, c3, c1);
    T = ins(T, g23, c3, c2i);
    T = ins(T, g33, c3, c3);

    rewriter.replaceOp(op, T);
    return mlir::success();
  }
};


struct RelExpandMetricPass
    : mlir::PassWrapper<RelExpandMetricPass, mlir::OperationPass<mlir::ModuleOp>> {
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(RelExpandMetricPass)

  mlir::StringRef getArgument() const final { return "rel-expand-metric"; }
  mlir::StringRef getDescription() const final {
    return "Expand relativity.metric.get into arith/tensor ops (Minkowski/Schwarzschild KS)";
  }

  void getDependentDialects(mlir::DialectRegistry &registry) const override {
    registry.insert<
      mlir::arith::ArithDialect,
      mlir::math::MathDialect,
      mlir::tensor::TensorDialect,
      mlir::vector::VectorDialect
    >();
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
