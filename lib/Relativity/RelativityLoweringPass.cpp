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
#include "../../Tensorium_Tex/lib/Frontend/Tensorium_AST.hpp"
#include "../../Tensorium_Tex/lib/Frontend/Tensorium_Tex.hpp"
#include <memory>
#include "mlir/IR/Attributes.h"  
#include "llvm/Support/Casting.h" 
#include "mlir/Dialect/Math/IR/Math.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "Utils/FormulaParser.h"


using namespace mlir;

using namespace mlir;
using namespace tensorium; 

namespace tensorium {
using FPNode = FormulaParser::ASTNode; 
std::vector<Token> tokenize(const std::string &input) {
    Lexer lexer(input);
    return lexer.tokenize();
}

}
Value resolveSymbol(const std::string &name, mlir::PatternRewriter &rewriter, mlir::Location loc, const SmallVector<Value> &inputs) {
    if (name == "M")     return inputs[0];
    if (name == "a")     return inputs[1];
    if (name == "theta") return inputs[2];
    if (name == "phi")   return inputs[3];
    if (name == "r")     return inputs[4];

    if (name == "rho") {
        Value r = inputs[4];
        Value a = inputs[1];
        Value theta = inputs[2];
        Value r2 = rewriter.create<arith::MulFOp>(loc, r, r);
        Value a2 = rewriter.create<arith::MulFOp>(loc, a, a);
        Value cos_theta = rewriter.create<math::CosOp>(loc, theta);
        Value cos2 = rewriter.create<arith::MulFOp>(loc, cos_theta, cos_theta);
        Value a2_cos2 = rewriter.create<arith::MulFOp>(loc, a2, cos2);
        Value sum = rewriter.create<arith::AddFOp>(loc, r2, a2_cos2);
        return rewriter.create<math::SqrtOp>(loc, sum);
    }
    if (name == "Delta") {
        Value r = inputs[4];
        Value M = inputs[0];
        Value a = inputs[1];
        Value r2 = rewriter.create<arith::MulFOp>(loc, r, r);
        Value a2 = rewriter.create<arith::MulFOp>(loc, a, a);
        Value two = rewriter.create<arith::ConstantOp>(loc, rewriter.getF64FloatAttr(2.0));
        Value two_M_r = rewriter.create<arith::MulFOp>(loc, two, rewriter.create<arith::MulFOp>(loc, M, r));
        Value diff = rewriter.create<arith::SubFOp>(loc, r2, two_M_r);
        return rewriter.create<arith::AddFOp>(loc, diff, a2);
    }

    llvm::errs() << "Unknown symbol in resolveSymbol: " << name << "\n";
    llvm_unreachable("Unhandled symbol in resolveSymbol");
}

using FormulaParser::NodeType;
mlir::Value emitFormula(FormulaParser::ASTNode *node,
                        mlir::PatternRewriter &rewriter,
                        mlir::Location loc,
                        mlir::ValueRange inputs) {
  if (!node) return nullptr;

  switch (node->type) {
  case NodeType::Number: {
    double v = std::stod(node->value);
    return rewriter.create<arith::ConstantOp>(loc, rewriter.getF64FloatAttr(v));
  }
  case NodeType::BinaryOp: {
    mlir::Value lhs = emitFormula(node->children[0].get(), rewriter, loc, inputs);
    mlir::Value rhs = emitFormula(node->children[1].get(), rewriter, loc, inputs);
    if (node->value == "+") return rewriter.create<arith::AddFOp>(loc, lhs, rhs);
    if (node->value == "-") return rewriter.create<arith::SubFOp>(loc, lhs, rhs);
    if (node->value == "*") return rewriter.create<arith::MulFOp>(loc, lhs, rhs);
    if (node->value == "/") return rewriter.create<arith::DivFOp>(loc, lhs, rhs);
    if (node->value == "^") return rewriter.create<math::PowFOp>(loc, lhs, rhs);
    llvm::report_fatal_error("Unsupported binary op");
  }
  
case NodeType::Symbol:
case NodeType::TensorSymbol:
    if (node->value == "^" || node->value == "{" || node->value == "}") {
        llvm::errs() << "ERREUR: Symbol token inattendu dans resolveSymbol: " << node->value << "\n";
        llvm::report_fatal_error("AST mal formé : opérateur traité comme symbole");
    }
    return resolveSymbol(node->value, rewriter, loc, llvm::to_vector<6>(inputs));

  case NodeType::FunctionCall: {
    mlir::Value arg = emitFormula(node->children[0].get(), rewriter, loc, inputs);
    if (node->value == "sin") return rewriter.create<math::SinOp>(loc, arg);
    if (node->value == "cos") return rewriter.create<math::CosOp>(loc, arg);
    if (node->value == "tan") return rewriter.create<math::TanOp>(loc, arg);
    llvm::report_fatal_error("Unsupported function");
  }



  case NodeType::UnaryOp: {
    mlir::Value s = emitFormula(node->children[0].get(), rewriter, loc, inputs);
    if (node->value == "-") return rewriter.create<arith::NegFOp>(loc, s);
    llvm::report_fatal_error("Unsupported unary op");
  }
  }
  llvm_unreachable("Unknown node type");
}

struct MetricComponentLowering
    : public OpRewritePattern<relativity::MetricComponentOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(relativity::MetricComponentOp op,
                                  PatternRewriter &rewriter) const override {
        Location loc = op.getLoc();
        ValueRange inputs = op.getOperands();

		auto attr = llvm::cast<StringAttr>(op->getAttr("formula"));
		std::string formulaStr = attr.getValue().str();
		auto tokens = FormulaParser::tokenize(formulaStr);
		for (auto &tok : tokens)
			llvm::errs() << "tok: " << tok << "\n";
		std::shared_ptr<FormulaParser::ASTNode> ast = FormulaParser::parse(tokens);
        Value lowered = emitFormula(ast.get(), rewriter, loc, inputs);
        rewriter.replaceOp(op, lowered);

		llvm::errs() << "AST = " << FormulaParser::ast_to_string(ast) << "\n";
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
