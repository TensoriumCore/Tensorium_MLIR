#include "RelAddCInterfacePass.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/IR/Attributes.h"
#include "mlir/IR/BuiltinOps.h"

using namespace mlir;
using namespace mlir::func;

namespace {

struct RelAddCInterfacePass
    : PassWrapper<RelAddCInterfacePass, OperationPass<ModuleOp>> {
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(RelAddCInterfacePass)

  StringRef getArgument() const final { return "rel-add-c-interface"; }
  StringRef getDescription() const final {
    return "Ajoute llvm.emit_c_interface aux fonctions exportées";
  }

  void runOnOperation() override {
    ModuleOp module = getOperation();
    MLIRContext *ctx = module.getContext();

    module.walk([&](mlir::func::FuncOp f) {
      if (f.isExternal())
        return;

      if (!f.getSymVisibility() || f.getSymVisibility() != "public")
        f.setSymVisibilityAttr(
            mlir::StringAttr::get(module.getContext(), "public"));

      if (!f->hasAttr("llvm.emit_c_interface"))
        f->setAttr("llvm.emit_c_interface",
                   mlir::UnitAttr::get(module.getContext()));
    });
  }
};

} // namespace

std::unique_ptr<Pass> mlir::relativity::createRelAddCInterfacePass() {
  return std::make_unique<RelAddCInterfacePass>();
}

void mlir::relativity::registerRelAddCInterfacePass() {
  PassRegistration<RelAddCInterfacePass>();
}
