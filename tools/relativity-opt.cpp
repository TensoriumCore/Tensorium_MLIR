#include "Relativity/Dialect.h"
#include "mlir/Tools/mlir-opt/MlirOptMain.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Math/IR/Math.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Tensor/IR/Tensor.h"

int main(int argc, char **argv) {
  mlir::DialectRegistry registry;

  registry.insert<mlir::func::FuncDialect, mlir::arith::ArithDialect,
                  mlir::tensor::TensorDialect, mlir::scf::SCFDialect,
                  mlir::memref::MemRefDialect, mlir::math::MathDialect,
                  mlir::relativity::RelativityDialect>();

  mlir::MLIRContext context;
  context.appendDialectRegistry(registry);
  context.loadAllAvailableDialects();

  context.getOrLoadDialect<mlir::relativity::RelativityDialect>();
  return mlir::asMainReturnCode(
      mlir::MlirOptMain(argc, argv, "Relativity optimizer driver", registry));
}
