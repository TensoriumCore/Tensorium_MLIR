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

using namespace mlir;

using namespace mlir;
using namespace tensorium; // ou ton namespace d'AST, si défini

namespace tensorium {

std::vector<Token> tokenize(const std::string &input) {
    Lexer lexer(input);
    return lexer.tokenize();
}

}
Value resolveSymbol(const std::string &name, const SmallVector<Value> &inputs) {
    if (name == "M") return inputs[0];
    if (name == "Delta") return inputs[1];
    if (name == "rho") return inputs[2];
    if (name == "sin") return inputs[3];
    if (name == "theta") return inputs[4];
    if (name == "a") return inputs[5];
    if (name == "r") return inputs[6];
    llvm_unreachable(("Unknown symbol: " + name).c_str());
}


mlir::Value emitFormula(tensorium::ASTNode *node,
                        mlir::PatternRewriter &rewriter,
                        mlir::Location loc,
                        mlir::ValueRange inputs) {
  using namespace mlir;

  if (!node)
    return nullptr;

  switch (node->type) {
    case tensorium::ASTNodeType::Number: {
      double val = std::stod(node->value);
      return rewriter.create<arith::ConstantOp>(
          loc, rewriter.getF64FloatAttr(val));
    }

    case tensorium::ASTNodeType::TensorSymbol:
    case tensorium::ASTNodeType::Symbol: {
      return resolveSymbol(node->value, inputs); 
    }

    case tensorium::ASTNodeType::BinaryOp: {
      assert(node->children.size() == 2 && "BinaryOp must have two children");
      Value lhs = emitFormula(node->children[0].get(), rewriter, loc, inputs);
      Value rhs = emitFormula(node->children[1].get(), rewriter, loc, inputs);

      if (node->value == "+")
        return rewriter.create<arith::AddFOp>(loc, lhs, rhs);
      else if (node->value == "-")
        return rewriter.create<arith::SubFOp>(loc, lhs, rhs);
      else if (node->value == "*")
        return rewriter.create<arith::MulFOp>(loc, lhs, rhs);
      else if (node->value == "/")
        return rewriter.create<arith::DivFOp>(loc, lhs, rhs);
      else if (node->value == "^")
        return rewriter.create<math::PowFOp>(loc, lhs, rhs);
      else
		  llvm::report_fatal_error(llvm::Twine("Unknown binary operator: ") + node->value);
    }

    case tensorium::ASTNodeType::UnaryOp: {
      assert(node->children.size() == 1 && "UnaryOp must have one child");
      Value child = emitFormula(node->children[0].get(), rewriter, loc, inputs);

      if (node->value == "-")
        return rewriter.create<arith::NegFOp>(loc, child);
      else
		  llvm::report_fatal_error(llvm::Twine("Unknown unary operator: ") + node->value);
    }

    default:
      llvm::report_fatal_error("Unsupported ASTNodeType in emitFormula");
  }
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
		auto tokens = tensorium::tokenize(formulaStr);
        tensorium::Parser parser(tokens);
        std::shared_ptr<tensorium::ASTNode> ast = parser.parse_expression();
        Value lowered = emitFormula(ast.get(), rewriter, loc, inputs);
        rewriter.replaceOp(op, lowered);

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
