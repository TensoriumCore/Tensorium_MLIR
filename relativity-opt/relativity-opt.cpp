#include "../lib/Relativity/AssembleMetricTensorPass.h"
#include "../lib/Relativity/LinearAlgebra/RelLinAlgLowering.h"
#include "../lib/Relativity/RelAddCInterfacePass/RelAddCInterfacePass.h"
#include "../lib/Relativity/RelExpandMetricPass.h"
#include "../lib/Relativity/RelExtractSpatialPass.h"
#include "../lib/Relativity/RelativityLoweringPass.h"
#include "../lib/Relativity/RelativitySimplifyPass.h"
#include "Relativity/RelativityDialect.h"
#include "Relativity/RelativityOpsDialect.cpp.inc"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/ControlFlow/IR/ControlFlow.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/Math/IR/Math.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Tensor/IR/Tensor.h"
#include "mlir/Dialect/Vector/IR/VectorOps.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/InitAllDialects.h"
#include "mlir/InitAllPasses.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Support/FileUtilities.h"
#include "mlir/Tools/mlir-opt/MlirOptMain.h"
#include "llvm/Config/llvm-config.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/InitLLVM.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/ToolOutputFile.h"
#include <mlir/Dialect/Linalg/IR/Linalg.h>

int main(int argc, char **argv) {
  mlir::registerAllPasses();
  mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
    return createLowerRelativityPass();
  });
  mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
    return mlir::relativity::createAssembleMetricTensorPass();
  });
  mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
    return mlir::relativity::createRelativitySimplifyPass();
  });
  mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
    return mlir::relativity::createRelExpandMetricPass();
  });
  mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
    return mlir::relativity::createRelExtractSpatialPass();
	});
  mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
    return mlir::relativity::createRelLinAlgLowerPass();
  });
  mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
    return mlir::relativity::createRelAddCInterfacePass();
  });

  mlir::DialectRegistry registry;
  mlir::registerAllDialects(registry); 
  registry.insert<mlir::relativity::RelativityDialect>();


  return mlir::asMainReturnCode(
      mlir::MlirOptMain(argc, argv, "Relativity optimizer driver\n", registry));
}
