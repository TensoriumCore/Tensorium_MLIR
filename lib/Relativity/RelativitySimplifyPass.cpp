#include "Relativity/RelativityDialect.h"
#include "Relativity/RelativityOps.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/raw_ostream.h"
#include <algorithm>
#include <regex>
#include <string>

using namespace mlir;
namespace {
struct RelativitySimplifyPass
    : public PassWrapper<RelativitySimplifyPass, OperationPass<ModuleOp>> {
  void runOnOperation() override {
    ModuleOp module = getOperation();
    static const std::regex fracRe(R"(\\?frac\{([^\}]*)\}\{([^\}]*)\})");
    static const std::regex fracSimpleRe(
        R"(\\?frac([a-zA-Z0-9^_]+)([a-zA-Z0-9^_]+))");
    static const std::regex expRe(R"(\^\{?([^\}]+)\}?)");

    module.walk([&](Operation *op) {
      if (auto metric = dyn_cast<relativity::MetricComponentOp>(op)) {
        if (auto attr = metric->getAttrOfType<StringAttr>("formula")) {
          std::string f = attr.getValue().str();

          f = std::regex_replace(f, fracRe, "($1)/($2)");
          f = std::regex_replace(f, fracSimpleRe, "($1)/($2)");
          f = std::regex_replace(f, expRe, "^$1");

          static const std::regex powRe(
              R"(pow\s*\(\s*([^,\)]+)\s*,\s*([^\)]+)\s*\))");
          f = std::regex_replace(f, powRe, "$1^$2");

          static const std::regex funcPowRe(
              R"((sin|cos|tan|exp|log)\(([^)]+)\)\s*\^\s*([0-9]+))");
          f = std::regex_replace(f, funcPowRe, "pow($1($2),$3)");
          f.erase(std::remove(f.begin(), f.end(), '{'), f.end());
          f.erase(std::remove(f.begin(), f.end(), '}'), f.end());

          if (f != attr.getValue().str()) {
            op->setAttr("formula", StringAttr::get(op->getContext(), f));
            llvm::errs() << "[RelativitySimplifyPass] Simplified: " << f
                         << "\n";
          }
        }
      }
    });
  }
  StringRef getArgument() const final { return "relativity-simplify"; }
  StringRef getDescription() const final {
    return "Cleans up LaTeX fractions, exponents, and curly braces in metric "
           "formulas";
  }
};
} // end anonymous namespace

namespace mlir {
namespace relativity {
std::unique_ptr<Pass> createRelativitySimplifyPass() {
  return std::make_unique<RelativitySimplifyPass>();
}
} // namespace relativity
} // namespace mlir
