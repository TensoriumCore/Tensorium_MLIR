#include "Relativity/RelativityOps.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/Dialect.h"    
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Tensor/IR/Tensor.h"
#include "llvm/Support/Casting.h" 
#include <memory>

using namespace mlir;
struct MetricComponentLowering
: public OpRewritePattern<relativity::MetricComponentOp> {
	using OpRewritePattern::OpRewritePattern;

	LogicalResult matchAndRewrite(relativity::MetricComponentOp op,
			PatternRewriter &rewriter) const override {
		Location loc = op.getLoc();
		auto operands = op.getOperands();
		Type resultTy = op.getResult().getType();

		auto call = rewriter.create<func::CallOp>(loc,
				"metric_component_impl",
				resultTy,
				operands);
		rewriter.replaceOp(op, call.getResult(0));
		return success();
	}
};


struct MetricTensorLowering : public OpRewritePattern<relativity::MetricTensorOp> {
	using OpRewritePattern::OpRewritePattern;

	LogicalResult matchAndRewrite(relativity::MetricTensorOp op,
			PatternRewriter &rewriter) const override {
		Location loc = op.getLoc();
		auto rawTy = op.getResult().getType();
		auto rankedTy = llvm::dyn_cast<mlir::RankedTensorType>(rawTy);
		assert(rankedTy && "expected RankedTensorType");
		Type elemTy = rankedTy.getElementType();

		ValueRange in = op.getOperands();
		Value g00 = in[0], g11 = in[1], g22 = in[2], g03 = in[3], g33 = in[4];
		Value g30 = g03;

		Value zero = rewriter.create<arith::ConstantOp>(
				loc, rewriter.getZeroAttr(elemTy));
		SmallVector<Value, 16> elems = {
			g00,  zero, zero, g03,
			zero, g11,  zero, zero,
			zero, zero, g22,  zero,
			g30,  zero, zero, g33
		};

		auto fromElem = rewriter.create<tensor::FromElementsOp>(
				loc, rankedTy, elems);
		rewriter.replaceOp(op, fromElem.getResult());
		return success();
	}
};

namespace {
	struct LowerRelativityPass
		: public PassWrapper<LowerRelativityPass,
		OperationPass<ModuleOp>> {
			void runOnOperation() override {
				getContext().getOrLoadDialect<mlir::arith::ArithDialect>();
				getContext().getOrLoadDialect<mlir::tensor::TensorDialect>();
				auto module = getOperation();
				if (!module.lookupSymbol<func::FuncOp>("metric_component_impl")) {
					OpBuilder b(&getContext());
					b.setInsertionPointToStart(module.getBody());
					FunctionType type = b.getFunctionType(
							SmallVector<Type, 7>(7, b.getF64Type()),
							b.getF64Type());
					b.create<func::FuncOp>(
							module.getLoc(),
							"metric_component_impl",
							type)
						.setPrivate();
				}

				RewritePatternSet patterns(&getContext());
				patterns.add<MetricComponentLowering, MetricTensorLowering>(&getContext());
				if (failed(applyPatternsGreedily(module, std::move(patterns))))
					signalPassFailure();
			}

			StringRef getArgument() const override { 
				return "lower-relativity"; 
			}
			StringRef getDescription() const override { 
				return "Lower Relativity dialect ops to standard MLIR"; 
			}
		};
} // end anonymous namespace

std::unique_ptr<Pass> createLowerRelativityPass() {
	return std::make_unique<LowerRelativityPass>();
}
