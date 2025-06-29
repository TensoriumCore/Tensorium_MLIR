#include "llvm/IR/PassManager.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/Constants.h"
#include "llvm/Support/raw_ostream.h"
#include <string>
#include <fstream>
#include <sys/stat.h>
#include <sys/types.h>

using namespace llvm;

namespace {
struct DumpTensoriumGpuFuncsPass : public PassInfoMixin<DumpTensoriumGpuFuncsPass> {
    PreservedAnalyses run(Module &M, ModuleAnalysisManager &) {
        std::string exportDir = "tensorium_export";
        struct stat st = {0};
        if (stat(exportDir.c_str(), &st) == -1) {
            mkdir(exportDir.c_str(), 0755);
        }

        GlobalVariable *annos = M.getNamedGlobal("llvm.global.annotations");
        if (!annos) return PreservedAnalyses::all();
        auto *CA = dyn_cast<ConstantArray>(annos->getOperand(0));
        if (!CA) return PreservedAnalyses::all();
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
                std::string fname = exportDir + "/" + fn->getName().str() + "_tensorium_gpu.ll";
                std::error_code EC;
				llvm::raw_fd_ostream ofs(fname, EC);
                if (EC) {
                    errs() << "[TensoriumPass] ERROR: Can't open " << fname << " for writing!\n";
                    continue;
                }
                // errs() << "[TensoriumPass] Exporting GPU function: " << fn->getName() << " -> " << fname << "\n";
                fn->print(ofs);
                ofs.close();

				bool hasSIMD = false;
				for (auto &BB : *fn) {
					for (auto &I : BB) {
						if (auto *call = dyn_cast<CallInst>(&I)) {
							if (Function *called = call->getCalledFunction()) {
								StringRef name = called->getName();
								if (name.starts_with("llvm.x86.") || name.starts_with("_mm") || name.starts_with("_mm256")) {
									hasSIMD = true;
									errs() << "[TensoriumPass][SIMD] Function " << fn->getName()
										<< " uses SIMD intrinsic: " << name << "\n";
								}
							}
						}
					}
				}
				if (hasSIMD) {
					std::string cudaStub = exportDir + "/" + fn->getName().str() + "_tensorium_gpu_stub.cu";
					std::ofstream cudaFile(cudaStub);
					if (cudaFile) {
						cudaFile << "__global__ void " << fn->getName().str() << "_kernel() { /* TODO: fallback implementation */ }\n";
						cudaFile.close();
						errs() << "[TensoriumPass][FALLBACK] Generated CUDA stub: " << cudaStub << "\n";
					}
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
