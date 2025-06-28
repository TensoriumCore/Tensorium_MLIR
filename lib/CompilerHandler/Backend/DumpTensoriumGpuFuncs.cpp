#include "llvm/IR/PassManager.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/Constants.h"
#include "llvm/Support/raw_ostream.h"
#include <string>

using namespace llvm;

namespace {
struct DumpTensoriumGpuFuncsPass : public PassInfoMixin<DumpTensoriumGpuFuncsPass> {
    PreservedAnalyses run(Module &M, ModuleAnalysisManager &) {
        GlobalVariable *annos = M.getNamedGlobal("llvm.global.annotations");
        if (!annos) return PreservedAnalyses::all();
        if (auto *CA = dyn_cast<ConstantArray>(annos->getOperand(0))) {
            for (unsigned i = 0; i < CA->getNumOperands(); ++i) {
                auto *S = dyn_cast<ConstantStruct>(CA->getOperand(i));
                if (!S) continue;
                auto *fn = dyn_cast<Function>(S->getOperand(0)->stripPointerCasts());
                auto *gv = dyn_cast<GlobalVariable>(S->getOperand(1)->stripPointerCasts());
                if (!fn || !gv) continue;
                auto *CDS = dyn_cast<ConstantDataArray>(gv->getInitializer());
                if (!CDS) continue;
                std::string anno = CDS->getAsCString().str();
                if (anno == "tensorium_gpu") {
                    errs() << "[TensoriumPass] Found GPU-annotated function: " << fn->getName() << "\n";
                    fn->print(errs());
                }
            }
        }
        return PreservedAnalyses::all();
    }
};
}

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo llvmGetPassPluginInfo() {
    return {
        LLVM_PLUGIN_API_VERSION, "DumpTensoriumGpuFuncsPass", LLVM_VERSION_STRING,
        [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, ModulePassManager &MPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                    if (Name == "dump-tensorium-gpu-funcs") {
                        MPM.addPass(DumpTensoriumGpuFuncsPass());
                        return true;
                    }
                    return false;
                });
        }
    };
}
