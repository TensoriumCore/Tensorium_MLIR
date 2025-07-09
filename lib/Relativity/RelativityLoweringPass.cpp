#include "RelativityLoweringPass.h"
#include "mlir/Pass/Pass.h"

using namespace mlir;


struct LowerRelativityPass 
  : public mlir::PassWrapper<LowerRelativityPass, mlir::OperationPass<mlir::ModuleOp>> {

    StringRef getArgument() const final { return "lower-relativity"; }
    StringRef getDescription() const final { return "Lower Relativity dialect ops to standard MLIR"; }

    void runOnOperation() override {
    }
};


std::unique_ptr<Pass> createLowerRelativityPass() {
    return std::make_unique<LowerRelativityPass>();
}
