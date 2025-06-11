// Create Dialect
// Lower ops of that dialect to arith
// From that to LLVM

#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/Operation.h"

#include "mlir/IR/DialectImplementation.h"
#include "mlir/IR/OpImplementation.h"
#include "mlir/Support/FileUtilities.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/IR/BuiltinTypes.h"

#include "mlir/Conversion/Passes.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Support/FileUtilities.h"
#include "llvm/Support/SourceMgr.h"

#include "mlir/IR/Verifier.h"
#include "mlir/Parser/Parser.h"

#include "Dialect.h.inc"

#include <iostream>

using namespace std;

namespace mlir {
namespace midialect {
#define GEN_PASS_DECL_CONVERTMYDIALECT2ARITH
#include "Passes.h.inc"

#define GEN_PASS_REGISTRATION
#include "Passes.h.inc"
} // namespace midialect
} // namespace mlir

#define GET_OP_CLASSES
#include "Ops.h.inc"

#include "Dialect.cpp.inc"
#include "llvm/ADT/TypeSwitch.h"

#define GET_OP_CLASSES
#include "Ops.cpp.inc"

using namespace mlir;
using namespace mlir::mydialect;

namespace mlir {
namespace mydialect {

void MyDialect::initialize() {

  addOperations<
#define GET_OP_LIST
#include "Ops.cpp.inc"
      >();
}
} // namespace mydialect

} // namespace mlir

namespace mlir {
namespace mydialect {
#define GEN_PASS_DEF_CONVERTMYDIALECT2ARITH
#include "Passes.h.inc"
} // namespace mydialect
} // namespace mlir

struct convertmydialect2arith
    : public mlir::mydialect::impl::convertmydialect2arithBase<
          convertmydialect2arith> {
  using convertmydialect2arithBase::convertmydialect2arithBase;

  void runOnOperation() override {
    auto mod = getOperation();

    mod->walk([&](mlir::mydialect::Const constOpIter) {
      OpBuilder b(constOpIter);
      auto newOp = b.create<mlir::arith::ConstantOp>(
          b.getUnknownLoc(), b.getI32Type(), b.getI32IntegerAttr(33));
      constOpIter.getResult().replaceAllUsesWith(newOp.getResult());
      constOpIter->erase();
    });

    mod->walk([&](mlir::mydialect::Metric metricOp) {
      OpBuilder b(metricOp);

      auto type = llvm::cast<mlir::RankedTensorType>(metricOp.getType());
      auto zero = b.getFloatAttr(type.getElementType(), 0.0);
      SmallVector<Attribute> values(type.getNumElements(), zero);

      auto denseAttr = DenseElementsAttr::get(type, values);
      auto constTensor =
          b.create<arith::ConstantOp>(metricOp.getLoc(), type, denseAttr);

      metricOp.getResult().replaceAllUsesWith(constTensor.getResult());
      metricOp.erase();
    });
  }
};

namespace mlir {
namespace mydialect {

void registerconvertmydialect2arith() {
  static mlir::PassRegistration<convertmydialect2arith> reg(
      [] { return std::make_unique<convertmydialect2arith>(); });
}

} // namespace mydialect
} // namespace mlir

int main(int argc, char **argv) {

  MLIRContext context;
  context.getOrLoadDialect<mydialect::MyDialect>();
  context.getOrLoadDialect<func::FuncDialect>();
  context.getOrLoadDialect<arith::ArithDialect>();

  mlir::mydialect::registerconvertmydialect2arith();
  PassManager pm(&context);
  if (argc > 1) {
    OwningOpRef<ModuleOp> module;
    auto buffer = mlir::openInputFile(argv[1]);
    if (!buffer) {
      llvm::errs() << "Cannot open file " << argv[1] << "\n";
      return 1;
    }

    llvm::SourceMgr sourceMgr;
    sourceMgr.AddNewSourceBuffer(std::move(buffer), SMLoc());
    module = parseSourceFile<ModuleOp>(sourceMgr, &context);
    if (!module) {
      llvm::errs() << "Failed to parse MLIR file\n";
      return 1;
    }

    pm.addPass(std::make_unique<convertmydialect2arith>());
    if (failed(pm.run(*module))) {
      llvm::errs() << "Failed to run passes\n";
      return 1;
    }

    module->dump();
    return 0;
  }
  OwningOpRef<ModuleOp> module = ModuleOp::create(UnknownLoc::get(&context));
  OpBuilder builder(&context);

  auto funcType = builder.getFunctionType({}, {});
  auto funcOp =
      builder.create<func::FuncOp>(builder.getUnknownLoc(), "main", funcType);

  module->push_back(funcOp);
  Block *entryBlock = funcOp.addEntryBlock();
  builder.setInsertionPointToStart(entryBlock);
  builder.create<mydialect::Const>(builder.getUnknownLoc(),
                                   builder.getI32Type());

  builder.create<func::ReturnOp>(builder.getUnknownLoc());

  module->dump();
  verify(module.get());

  pm.addPass(createconvertmydialect2arith());
  if (failed(pm.run(*module))) {
    llvm::errs() << "Failed to run passes\n";
    return 1;
  }

  module->dump();

  builder.setInsertionPointToStart(entryBlock);

  auto metricType = RankedTensorType::get({4, 4}, builder.getF64Type());

  auto metricOp =
      builder.create<mydialect::Metric>(builder.getUnknownLoc(), metricType,
                                        builder.getStringAttr("kerr_metric"));
  builder.create<func::ReturnOp>(builder.getUnknownLoc());
  return 0;
}
