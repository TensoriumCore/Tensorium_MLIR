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

	if (name == "sin" || name == "cos" || name == "tan") {
		llvm::errs() << "[WARNING] Function " << name << " called as symbol. Patching as 0.0\n";
		return rewriter.create<arith::ConstantOp>(loc, rewriter.getF64FloatAttr(0.0));
	}
    llvm::errs() << "Unknown symbol in resolveSymbol: " << name << "\n";
    llvm_unreachable("Unhandled symbol in resolveSymbol");
}

using FormulaParser::NodeType;

#include "mlir/IR/Attributes.h"   
#include "llvm/Support/Casting.h" 

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/IR/Attributes.h"
#include "mlir/Dialect/Math/IR/Math.h"
#include "llvm/Support/Casting.h"
#include "Utils/FormulaParser.h"

mlir::Value emitFormula(tensorium::ASTNode *node,
                        mlir::PatternRewriter &rewriter,
                        mlir::Location loc,
                        mlir::ValueRange inputs) {
  if (!node)
    return nullptr;

  using NT = tensorium::ASTNodeType;
  switch (node->type) {
  case NT::Number: {
    double v = std::stod(node->value);
    return rewriter.create<arith::ConstantOp>(loc,
        rewriter.getF64FloatAttr(v));
  }

  case NT::BinaryOp: {
    // Puissance robuste
    if (node->value == "^") {
      auto *base = node->children[0].get();
      auto *exp  = node->children[1].get();
      mlir::Value lhs = emitFormula(base, rewriter, loc, inputs);
      mlir::Value rhs = emitFormula(exp,  rewriter, loc, inputs);

      bool hasExpVal = false;
      double expVal = 0.0;
      if (auto cstOp = rhs.getDefiningOp<arith::ConstantOp>()) {
        if (auto fattr = llvm::dyn_cast<FloatAttr>(cstOp.getValue())) {
          expVal = fattr.getValueAsDouble();
          hasExpVal = true;
        }
      }
      if (!hasExpVal) {
        if (auto negOp = rhs.getDefiningOp<arith::NegFOp>()) {
          auto operand = negOp.getOperand();
          if (auto innerCst = operand.getDefiningOp<arith::ConstantOp>()) {
            if (auto fattr = llvm::dyn_cast<FloatAttr>(innerCst.getValue())) {
              expVal = -fattr.getValueAsDouble();
              hasExpVal = true;
            }
          }
        }
      }
    //   if (hasExpVal && expVal == -1.0) {
    //     auto one = rewriter.create<arith::ConstantOp>(
    //         loc, rewriter.getF64FloatAttr(1.0));
    //     return rewriter.create<arith::DivFOp>(loc, one, lhs);
    //   }
      return rewriter.create<math::PowFOp>(loc, lhs, rhs);
    }

    mlir::Value lhs = emitFormula(node->children[0].get(), rewriter, loc, inputs);
    mlir::Value rhs = emitFormula(node->children[1].get(), rewriter, loc, inputs);
    if (node->value == "+") return rewriter.create<arith::AddFOp>(loc, lhs, rhs);
    if (node->value == "-") return rewriter.create<arith::SubFOp>(loc, lhs, rhs);
    if (node->value == "*") return rewriter.create<arith::MulFOp>(loc, lhs, rhs);
    if (node->value == "/") return rewriter.create<arith::DivFOp>(loc, lhs, rhs);
    llvm::report_fatal_error("Unsupported binary op");
  }

  case NT::Symbol:
  case NT::TensorSymbol: {
    auto v = node->value;
    if ((v == "sin" || v == "\\sin") && !node->children.empty())
      return rewriter.create<math::SinOp>(
          loc, emitFormula(node->children[0].get(), rewriter, loc, inputs));
    if ((v == "cos" || v == "\\cos") && !node->children.empty())
      return rewriter.create<math::CosOp>(
          loc, emitFormula(node->children[0].get(), rewriter, loc, inputs));
    if ((v == "tan" || v == "\\tan") && !node->children.empty())
      return rewriter.create<math::TanOp>(
          loc, emitFormula(node->children[0].get(), rewriter, loc, inputs));
    return resolveSymbol(v, rewriter, loc, llvm::to_vector<6>(inputs));
  }

  case NT::FunctionCall: {
    mlir::Value a = emitFormula(node->children[0].get(), rewriter, loc, inputs);
    if (node->value == "sin" || node->value == "\\sin")
      return rewriter.create<math::SinOp>(loc, a);
    if (node->value == "cos" || node->value == "\\cos")
      return rewriter.create<math::CosOp>(loc, a);
    if (node->value == "tan" || node->value == "\\tan")
      return rewriter.create<math::TanOp>(loc, a);
    llvm::report_fatal_error("Unsupported function");
  }

  case NT::UnaryOp: {
    mlir::Value s = emitFormula(node->children[0].get(), rewriter, loc, inputs);
    if (node->value == "-") return rewriter.create<arith::NegFOp>(loc, s);
    llvm::report_fatal_error("Unsupported unary op");
  }

  default:
    llvm_unreachable("Unknown node type");
  }
}

struct MetricComponentLowering
    : public OpRewritePattern<relativity::MetricComponentOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(relativity::MetricComponentOp op,
                                  PatternRewriter &rewriter) const override {
        Location loc = op.getLoc();
        ValueRange inputs = op.getOperands();

		auto attr = op->getAttrOfType<StringAttr>("formula");
		std::string str = attr.getValue().str();
		auto tokens = tensorium::tokenize(str);
		tensorium::Parser parser(tokens);
		auto stmts = parser.parse_statements();
		if (stmts.empty())
			return rewriter.notifyMatchFailure(op, "could not parse formula");
		auto ast = stmts.front();
		Value lowered = emitFormula(ast.get(), rewriter, loc, inputs);
		rewriter.replaceOp(op, lowered);
		return success();    }
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

        SmallVector<Value, 5> args;
        for (unsigned i = 0; i < 5; ++i) {
            if (i < in.size())
                args.push_back(in[i]);
            else
                args.push_back(rewriter.create<arith::ConstantOp>(loc, rewriter.getZeroAttr(elemTy)));
        }

		Value g00 = args[2]; 
		Value g11 = args[1];
		Value g22 = args[3];
		Value g33 = args[0];

		Value zero = rewriter.create<arith::ConstantOp>(loc, rewriter.getZeroAttr(elemTy));
		SmallVector<Value, 16> elems = {
			g00,  zero, zero, zero,
			zero, g11,  zero, zero,
			zero, zero, g22,  zero,
			zero, zero, zero, g33
		};


		auto fromElem = rewriter.create<tensor::FromElementsOp>(loc, rankedTy, elems);
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
