#include "../lib/Relativity/AssembleMetricTensorPass.h"
#include "../lib/Relativity/RelExpandMetricPass.h"
#include "../lib/Relativity/RelExtractSpatialPass.h"
#include "../lib/Relativity/RelativityLoweringPass.h"
#include "../lib/Relativity/RelativitySimplifyPass.h"
#include "Relativity/RelativityDialect.h"
#include "Relativity/RelativityOpsDialect.cpp.inc"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Math/IR/Math.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Tensor/IR/Tensor.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/InitAllDialects.h"
#include "mlir/InitAllPasses.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Support/FileUtilities.h"
#include "mlir/Tools/mlir-opt/MlirOptMain.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/InitLLVM.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/ToolOutputFile.h"
#include <mlir/Dialect/Linalg/IR/Linalg.h>

#include "llvm/Config/llvm-config.h"
int main(int argc, char **argv) {
// #if LLVM_VERSION_MAJOR < 22
// 	llvm::InitLLVM y(argc, argv);
// #endif

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

	mlir::DialectRegistry registry;
	registry.insert<mlir::relativity::RelativityDialect>();
	registry.insert<mlir::math::MathDialect>();
	registry.insert<mlir::arith::ArithDialect>();
	registry.insert<mlir::func::FuncDialect>();
	registry.insert<mlir::tensor::TensorDialect>();
	registry.insert<mlir::scf::SCFDialect>();
	registry.insert<mlir::memref::MemRefDialect>();
	registry.insert<mlir::linalg::LinalgDialect>();

	return mlir::asMainReturnCode(
		mlir::MlirOptMain(argc, argv, "Relativity optimizer driver\n", registry));
}
