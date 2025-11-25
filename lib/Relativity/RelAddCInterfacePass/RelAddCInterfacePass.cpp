#include "RelAddCInterfacePass.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/Vector/IR/VectorOps.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Attributes.h"
#include "mlir/Pass/Pass.h"

using namespace mlir;
using namespace mlir::func;

namespace {

static bool isVec4F64(Type t) {
  if (auto vt = dyn_cast<VectorType>(t))
    return vt.getRank() == 1 && vt.getDimSize(0) == 4 &&
           vt.getElementType().isF64();
  return false;
}

struct RelAddCInterfacePass
    : PassWrapper<RelAddCInterfacePass, OperationPass<ModuleOp>> {
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(RelAddCInterfacePass)

  StringRef getArgument() const final override { return "rel-add-c-interface"; }
  StringRef getDescription() const final override {
    return "Ajoute llvm.emit_c_interface aux fonctions exportées et "
           "wrappe les vector<4xf64> en memref<4xf64> (ABI-safe).";
  }

  void runOnOperation() override {
    ModuleOp module = getOperation();
    MLIRContext *ctx = module.getContext();
    OpBuilder b(ctx);

    SmallVector<FuncOp> toProcess;

    module.walk([&](FuncOp f) {
      if (f.isExternal())
        return;
      if (f.getSymVisibility() != "public")
        return;
      if (llvm::any_of(f.getFunctionType().getInputs(), isVec4F64))
        toProcess.push_back(f);
      else {
        f.setSymVisibilityAttr(StringAttr::get(ctx, "public"));
        if (!f->hasAttr("llvm.emit_c_interface"))
          f->setAttr("llvm.emit_c_interface", UnitAttr::get(ctx));
      }
    });

    for (FuncOp f : toProcess) {
      Location loc = f.getLoc();
      b.setInsertionPoint(f);

      std::string implName = (f.getName() + "_impl").str();
      f.setName(implName);
      f.setSymVisibility("private");

      FunctionType oldTy = f.getFunctionType();

      SmallVector<Type> inTys;
      SmallVector<bool> wasVec;
      for (Type t : oldTy.getInputs()) {
        if (isVec4F64(t)) {
          inTys.push_back(MemRefType::get({4}, b.getF64Type()));
          wasVec.push_back(true);
        } else {
          inTys.push_back(t);
          wasVec.push_back(false);
        }
      }
      auto newTy = b.getFunctionType(inTys, oldTy.getResults());

      auto wrapper = b.create<FuncOp>(loc, implName.substr(
                                          0, implName.size() - 5),
                                      newTy);
      wrapper.setSymVisibility("public");
      wrapper->setAttr("llvm.emit_c_interface", UnitAttr::get(ctx));

      Block *entry = wrapper.addEntryBlock();
      b.setInsertionPointToStart(entry);

      SmallVector<Value> callArgs;
      Value c0 = b.create<arith::ConstantIndexOp>(loc, 0);
      Value zero = b.create<arith::ConstantOp>(loc, b.getF64Type(),
                                               b.getFloatAttr(b.getF64Type(), 0.0));
      for (auto [arg, was] : llvm::zip(entry->getArguments(), wasVec)) {
        if (!was) {
          callArgs.push_back(arg);
        } else {
          auto vecTy = VectorType::get({4}, b.getF64Type());
          Value v = b.create<vector::TransferReadOp>(loc, vecTy, arg,
                                                     ValueRange{c0}, zero);
          callArgs.push_back(v);
        }
      }

      auto call = b.create<func::CallOp>(loc, f, callArgs);

      if (newTy.getNumResults() == 0)
        b.create<func::ReturnOp>(loc);
      else
        b.create<func::ReturnOp>(loc, call.getResults());
    }
  }
};

} // namespace

std::unique_ptr<Pass> mlir::relativity::createRelAddCInterfacePass() {
  return std::make_unique<RelAddCInterfacePass>();
}

void mlir::relativity::registerRelAddCInterfacePass() {
  PassRegistration<RelAddCInterfacePass>();
}
