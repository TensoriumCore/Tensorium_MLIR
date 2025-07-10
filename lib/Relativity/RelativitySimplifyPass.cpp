
#include "mlir/IR/PatternMatch.h"
#include "Relativity/RelativityOps.h"
#include "Relativity/RelativityDialect.h"
#include "mlir/Pass/Pass.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/Support/LogicalResult.h"
#include "Utils/FormulaParser.h"

#include <regex>
#include <string>

// Adapt to your real namespace if needed!
namespace mlir {
namespace relativity {

struct RelativitySimplifyPass
	: public PassWrapper<RelativitySimplifyPass, OperationPass<mlir::ModuleOp>>
{
	void runOnOperation() override {
		auto module = getOperation();
		module.walk([&](Operation *op) {
			if (auto metric = llvm::dyn_cast_or_null<relativity::MetricComponentOp>(op)) {
				auto origFormulaAttr = metric->getAttrOfType<StringAttr>("formula");
				if (!origFormulaAttr) return;

				std::string origFormula = origFormulaAttr.str();
				std::string newFormula = FormulaParser::simplify_formula(origFormula);

				if (newFormula != origFormula) {
					op->setAttr("formula", StringAttr::get(op->getContext(), newFormula));
					llvm::errs() << "[RelativitySimplifyPass] Simplified: '" << origFormula << "' -> '" << newFormula << "'\n";
				} else if (newFormula.find("frac") != std::string::npos || newFormula.find('^') != std::string::npos) {
					llvm::errs() << "[RelativitySimplifyPass][WARN] Unparsed formula: " << newFormula << "\n";
				}
			}
		});
	}

	StringRef getArgument() const final { return "relativity-simplify"; }
	StringRef getDescription() const final { return "Simplifies Relativity metric formulas"; }
	MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(RelativitySimplifyPass)
};

std::unique_ptr<mlir::Pass> createRelativitySimplifyPass() {
	return std::make_unique<RelativitySimplifyPass>();
}

} // namespace relativity
} // namespace mlir

