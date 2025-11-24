#include "RelExpandMetricPass.h"
#include "Relativity/RelativityOps.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Math/IR/Math.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Tensor/IR/Tensor.h"
#include "mlir/Dialect/Vector/IR/VectorOps.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/Casting.h"
#include <tuple>

using namespace mlir;
using namespace mlir::relativity;

namespace {

struct ADMComponents {
  Value alpha;
  Value beta[3];
  Value gamma[3][3];
};

void invert3x3(OpBuilder &b, Location loc, Value m[3][3], Value inv[3][3]) {

  auto mul = [&](Value x, Value y) {
    return b.create<arith::MulFOp>(loc, x, y);
  };
  auto sub = [&](Value x, Value y) {
    return b.create<arith::SubFOp>(loc, x, y);
  };
  auto add = [&](Value x, Value y) {
    return b.create<arith::AddFOp>(loc, x, y);
  };
  auto div = [&](Value x, Value y) {
    return b.create<arith::DivFOp>(loc, x, y);
  };

  Value A = m[0][0], B = m[0][1], C = m[0][2];
  Value D = m[1][0], E = m[1][1], F = m[1][2];
  Value G = m[2][0], H = m[2][1], I = m[2][2];

  Value EI_FH = sub(mul(E, I), mul(F, H));
  Value FG_DI = sub(mul(F, G), mul(D, I));
  Value DH_EG = sub(mul(D, H), mul(E, G));

  Value CH_BI = sub(mul(C, H), mul(B, I));
  Value AI_CG = sub(mul(A, I), mul(C, G));
  Value BG_AH = sub(mul(B, G), mul(A, H));

  Value BF_CE = sub(mul(B, F), mul(C, E));
  Value CD_AF = sub(mul(C, D), mul(A, F));
  Value AE_BD = sub(mul(A, E), mul(B, D));

  Value det = add(mul(A, EI_FH), add(mul(B, FG_DI), mul(C, DH_EG)));

  inv[0][0] = div(EI_FH, det);
  inv[0][1] = div(CH_BI, det);
  inv[0][2] = div(BF_CE, det);

  inv[1][0] = div(FG_DI, det);
  inv[1][1] = div(AI_CG, det);
  inv[1][2] = div(CD_AF, det);

  inv[2][0] = div(DH_EG, det);
  inv[2][1] = div(BG_AH, det);
  inv[2][2] = div(AE_BD, det);
}

ADMComponents computeADMGeneric(OpBuilder &b, Location loc, Value g[4][4]) {
  ADMComponents res;
  auto f64 = b.getF64Type();
  auto zero = b.create<arith::ConstantFloatOp>(loc, llvm::APFloat(0.0), f64);

  for (int i = 0; i < 3; ++i)
    for (int j = 0; j < 3; ++j)
      res.gamma[i][j] = g[i + 1][j + 1];

  Value gammaInv[3][3];
  invert3x3(b, loc, res.gamma, gammaInv);

  for (int i = 0; i < 3; ++i) {
    Value sum = zero;
    for (int j = 0; j < 3; ++j) {
      auto term = b.create<arith::MulFOp>(loc, gammaInv[i][j], g[0][j + 1]);
      sum = b.create<arith::AddFOp>(loc, sum, term);
    }
    res.beta[i] = sum;
  }

  Value shiftDotG0 = zero;
  for (int k = 0; k < 3; ++k) {
    auto term = b.create<arith::MulFOp>(loc, res.beta[k], g[0][k + 1]);
    shiftDotG0 = b.create<arith::AddFOp>(loc, shiftDotG0, term);
  }

  auto diff = b.create<arith::SubFOp>(loc, shiftDotG0, g[0][0]);
  res.alpha = b.create<math::SqrtOp>(loc, diff);

  return res;
}

void buildSchwarzschildMetricValues(OpBuilder &rewriter, Location loc, Value t,
                                    Value x, Value y, Value z, double M,
                                    double eps, Value g[4][4]) {
  auto f64 = rewriter.getF64Type();
  auto cstM =
      rewriter.create<arith::ConstantFloatOp>(loc, llvm::APFloat(M), f64);

  // Calcul de r
  auto x2 = rewriter.create<arith::MulFOp>(loc, x, x);
  auto y2 = rewriter.create<arith::MulFOp>(loc, y, y);
  auto z2 = rewriter.create<arith::MulFOp>(loc, z, z);
  auto s2 = rewriter.create<arith::AddFOp>(
      loc, rewriter.create<arith::AddFOp>(loc, x2, y2), z2);

  auto eps2 = rewriter.create<arith::ConstantFloatOp>(
      loc, llvm::APFloat(eps * eps), f64);
  auto lt =
      rewriter.create<arith::CmpFOp>(loc, arith::CmpFPredicate::OLT, s2, eps2);
  auto s2s = rewriter.create<arith::SelectOp>(loc, lt, eps2, s2);
  auto r = rewriter.create<math::SqrtOp>(loc, s2s);

  auto H = rewriter.create<arith::DivFOp>(loc, cstM, r);

  Value l[4];
  l[0] = rewriter.create<arith::ConstantFloatOp>(loc, llvm::APFloat(1.0), f64);
  l[1] = rewriter.create<arith::DivFOp>(loc, x, r);
  l[2] = rewriter.create<arith::DivFOp>(loc, y, r);
  l[3] = rewriter.create<arith::DivFOp>(loc, z, r);

  Value eta[4];
  eta[0] =
      rewriter.create<arith::ConstantFloatOp>(loc, llvm::APFloat(-1.0), f64);
  eta[1] = l[0];
  eta[2] = l[0];
  eta[3] = l[0];

  auto c2 =
      rewriter.create<arith::ConstantFloatOp>(loc, llvm::APFloat(2.0), f64);
  auto twoH = rewriter.create<arith::MulFOp>(loc, c2, H);

  for (int i = 0; i < 4; ++i) {
    for (int j = 0; j < 4; ++j) {
      auto li_lj = rewriter.create<arith::MulFOp>(loc, l[i], l[j]);
      auto term = rewriter.create<arith::MulFOp>(loc, twoH, li_lj);

      if (i == j) {
        g[i][j] = rewriter.create<arith::AddFOp>(loc, eta[i], term);
      } else {
        g[i][j] = term;
      }
    }
  }
}

void buildMinkowskiMetricValues(OpBuilder &rewriter, Location loc,
                                Value g[4][4]) {
  auto f64 = rewriter.getF64Type();
  auto zero =
      rewriter.create<arith::ConstantFloatOp>(loc, llvm::APFloat(0.0), f64);
  auto one =
      rewriter.create<arith::ConstantFloatOp>(loc, llvm::APFloat(1.0), f64);
  auto minusOne =
      rewriter.create<arith::ConstantFloatOp>(loc, llvm::APFloat(-1.0), f64);

  for (int i = 0; i < 4; ++i)
    for (int j = 0; j < 4; ++j)
      g[i][j] = zero;

  g[0][0] = minusOne;
  g[1][1] = one;
  g[2][2] = one;
  g[3][3] = one;
}

std::tuple<Value, Value, Value>
generateADMLoops(OpBuilder &rewriter, Location loc, Value inputTensor,
                 Value outAlpha, Value outBeta, Value outGamma,
                 ArrayRef<int64_t> shape, int currentDim,
                 SmallVectorImpl<Value> &indices, StringRef metricName,
                 double M, double eps) {

  if (currentDim == (int)shape.size()) {
    auto c0 = rewriter.create<arith::ConstantIndexOp>(loc, 0);
    auto c1 = rewriter.create<arith::ConstantIndexOp>(loc, 1);
    auto c2 = rewriter.create<arith::ConstantIndexOp>(loc, 2);
    auto c3 = rewriter.create<arith::ConstantIndexOp>(loc, 3);

    auto extractCoord = [&](Value idx) {
      SmallVector<Value> accessIndices(indices.begin(), indices.end());
      accessIndices.push_back(idx);
      return rewriter.create<tensor::ExtractOp>(loc, inputTensor,
                                                accessIndices);
    };

    Value t = extractCoord(c0);
    Value x = extractCoord(c1);
    Value y = extractCoord(c2);
    Value z = extractCoord(c3);

    Value g[4][4];
    if (metricName == "schwarzschild_ks") {
      buildSchwarzschildMetricValues(rewriter, loc, t, x, y, z, M, eps, g);
    } else {
      buildMinkowskiMetricValues(rewriter, loc, g);
    }

    ADMComponents adm = computeADMGeneric(rewriter, loc, g);

    Value newAlpha =
        rewriter.create<tensor::InsertOp>(loc, adm.alpha, outAlpha, indices);

    Value betaVec = rewriter.create<tensor::FromElementsOp>(
        loc, ValueRange{adm.beta[0], adm.beta[1], adm.beta[2]});
    SmallVector<OpFoldResult> offsets(indices.begin(), indices.end());
    offsets.push_back(rewriter.getIndexAttr(0));
    SmallVector<OpFoldResult> sizes(indices.size(), rewriter.getIndexAttr(1));
    sizes.push_back(rewriter.getIndexAttr(3));
    SmallVector<OpFoldResult> strides(indices.size() + 1,
                                      rewriter.getIndexAttr(1));
    Value newBeta = rewriter.create<tensor::InsertSliceOp>(
        loc, betaVec, outBeta, offsets, sizes, strides);

    SmallVector<Value> flatGamma;
    for (int i = 0; i < 3; ++i)
      for (int j = 0; j < 3; ++j)
        flatGamma.push_back(adm.gamma[i][j]);

    Value gammaMat = rewriter.create<tensor::FromElementsOp>(
        loc, RankedTensorType::get({3, 3}, rewriter.getF64Type()), flatGamma);

    SmallVector<OpFoldResult> offsetsG(indices.begin(), indices.end());
    offsetsG.push_back(rewriter.getIndexAttr(0));
    offsetsG.push_back(rewriter.getIndexAttr(0));
    SmallVector<OpFoldResult> sizesG(indices.size(), rewriter.getIndexAttr(1));
    sizesG.push_back(rewriter.getIndexAttr(3));
    sizesG.push_back(rewriter.getIndexAttr(3));
    SmallVector<OpFoldResult> stridesG(indices.size() + 2,
                                       rewriter.getIndexAttr(1));
    Value newGamma = rewriter.create<tensor::InsertSliceOp>(
        loc, gammaMat, outGamma, offsetsG, sizesG, stridesG);

    return {newAlpha, newBeta, newGamma};
  }

  Value lower = rewriter.create<arith::ConstantIndexOp>(loc, 0);
  Value upper = rewriter.create<arith::ConstantIndexOp>(loc, shape[currentDim]);
  Value step = rewriter.create<arith::ConstantIndexOp>(loc, 1);

  auto loop = rewriter.create<scf::ForOp>(
      loc, lower, upper, step, ValueRange{outAlpha, outBeta, outGamma},
      [&](OpBuilder &b, Location loc, Value iv, ValueRange args) {
        indices.push_back(iv);
        auto [resA, resB, resG] = generateADMLoops(
            b, loc, inputTensor, args[0], args[1], args[2], shape,
            currentDim + 1, indices, metricName, M, eps);
        indices.pop_back();
        b.create<scf::YieldOp>(loc, ValueRange{resA, resB, resG});
      });

  return {loop.getResult(0), loop.getResult(1), loop.getResult(2)};
}

struct ExpandMetricGetPattern
    : mlir::OpRewritePattern<mlir::relativity::MetricGetOp> {
  using OpRewritePattern<mlir::relativity::MetricGetOp>::OpRewritePattern;

  ExpandMetricGetPattern(mlir::MLIRContext *ctx)
      : OpRewritePattern<mlir::relativity::MetricGetOp>(ctx) {}

  mlir::LogicalResult
  matchAndRewrite(mlir::relativity::MetricGetOp op,
                  mlir::PatternRewriter &rewriter) const override {
    auto nameAttr = op->getAttrOfType<mlir::StringAttr>("name");
    if (!nameAttr)
      return mlir::failure();

    StringRef name = nameAttr.getValue();
    const auto loc = op.getLoc();

    double Mdef = 1.0;
    double eps = 1e-15;
    if (auto dict = op->getAttrOfType<mlir::DictionaryAttr>("params")) {
      if (auto any = dict.get("M"))
        if (auto Ma = llvm::dyn_cast<mlir::FloatAttr>(any))
          Mdef = Ma.getValueAsDouble();
      if (auto Ea = llvm::dyn_cast_or_null<mlir::FloatAttr>(dict.get("eps")))
        eps = Ea.getValueAsDouble();
    }

    Value input = op.getX();
    Type inputType = input.getType();
    auto f64 = rewriter.getF64Type();

    auto tensorType = dyn_cast<RankedTensorType>(inputType);
    auto vecType = dyn_cast<VectorType>(inputType);

    if (!tensorType && !vecType)
      return rewriter.notifyMatchFailure(
          op, "Input must be a tensor or vector type");

    ArrayRef<int64_t> shape;
    if (tensorType) {
      shape = tensorType.getShape();
      if (shape.empty() || shape.back() != 4)
        return rewriter.notifyMatchFailure(op, "Last dim must be 4 (t,x,y,z)");
    } else if (vecType) {
      if (vecType.getRank() != 1 || vecType.getDimSize(0) != 4)
        return rewriter.notifyMatchFailure(op, "Vector input must be size 4");
    }

    if (name == "minkowski") {
      Value alphaCst =
          rewriter.create<arith::ConstantFloatOp>(loc, llvm::APFloat(1.0), f64);
      Value zeroCst =
          rewriter.create<arith::ConstantFloatOp>(loc, llvm::APFloat(0.0), f64);

      Value betaCst = rewriter.create<tensor::FromElementsOp>(
          loc, RankedTensorType::get({3}, f64),
          ValueRange{zeroCst, zeroCst, zeroCst});

      Value gammaCst = rewriter.create<tensor::FromElementsOp>(
          loc, RankedTensorType::get({3, 3}, f64),
          ValueRange{alphaCst, zeroCst, zeroCst, zeroCst, alphaCst, zeroCst,
                     zeroCst, zeroCst, alphaCst});

      rewriter.replaceOp(op, {alphaCst, betaCst, gammaCst});
      return mlir::success();
    }

    if (name != "schwarzschild_ks")
      return mlir::failure();

    if (vecType) {
      auto i0 = rewriter.create<arith::ConstantIndexOp>(loc, 0);
      auto i1 = rewriter.create<arith::ConstantIndexOp>(loc, 1);
      auto i2 = rewriter.create<arith::ConstantIndexOp>(loc, 2);
      auto i3 = rewriter.create<arith::ConstantIndexOp>(loc, 3);

      Value t = rewriter.create<vector::ExtractElementOp>(loc, input, i0);
      Value x = rewriter.create<vector::ExtractElementOp>(loc, input, i1);
      Value y = rewriter.create<vector::ExtractElementOp>(loc, input, i2);
      Value z = rewriter.create<vector::ExtractElementOp>(loc, input, i3);

      Value g[4][4];
      buildSchwarzschildMetricValues(rewriter, loc, t, x, y, z, Mdef, eps, g);
      ADMComponents adm = computeADMGeneric(rewriter, loc, g);

      Value betaVec = rewriter.create<tensor::FromElementsOp>(
          loc, RankedTensorType::get({3}, f64),
          ValueRange{adm.beta[0], adm.beta[1], adm.beta[2]});

      SmallVector<Value> flatGamma;
      for (int i = 0; i < 3; ++i)
        for (int j = 0; j < 3; ++j)
          flatGamma.push_back(adm.gamma[i][j]);

      Value gammaMat = rewriter.create<tensor::FromElementsOp>(
          loc, RankedTensorType::get({3, 3}, f64), flatGamma);

      rewriter.replaceOp(op, {adm.alpha, betaVec, gammaMat});
      return mlir::success();
    }

    if (tensorType) {
      SmallVector<int64_t> gridDims(shape.begin(), shape.end() - 1);

      auto emptyAlpha = rewriter.create<tensor::EmptyOp>(loc, gridDims, f64);

      SmallVector<int64_t> betaDims = gridDims;
      betaDims.push_back(3);
      auto emptyBeta = rewriter.create<tensor::EmptyOp>(loc, betaDims, f64);

      SmallVector<int64_t> gammaDims = gridDims;
      gammaDims.push_back(3);
      gammaDims.push_back(3);
      auto emptyGamma = rewriter.create<tensor::EmptyOp>(loc, gammaDims, f64);

      SmallVector<Value> indices;
      auto [resAlpha, resBeta, resGamma] =
          generateADMLoops(rewriter, loc, input, emptyAlpha, emptyBeta,
                           emptyGamma, gridDims, 0, indices, name, Mdef, eps);

      rewriter.replaceOp(op, {resAlpha, resBeta, resGamma});
      return mlir::success();
    }

    return mlir::failure();
  }
};

struct RelExpandMetricPass
    : mlir::PassWrapper<RelExpandMetricPass,
                        mlir::OperationPass<mlir::ModuleOp>> {
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(RelExpandMetricPass)

  mlir::StringRef getArgument() const final { return "rel-expand-metric"; }
  mlir::StringRef getDescription() const final {
    return "Expand relativity.metric.get into ADM variables (Alpha, Beta, "
           "Gamma)";
  }

  void getDependentDialects(mlir::DialectRegistry &registry) const override {
    registry.insert<mlir::arith::ArithDialect, mlir::math::MathDialect,
                    mlir::tensor::TensorDialect, mlir::vector::VectorDialect,
                    mlir::scf::SCFDialect>();
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
