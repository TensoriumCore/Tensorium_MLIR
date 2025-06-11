#include "mlir/InitAllDialects.h"
#include "mlir/InitAllPasses.h"
#include "mlir/Tools/mlir-opt/MlirOptMain.h"
#include "Relativity/Dialect.h"
#include "Relativity/RelativityDialect.h.inc"
#define GET_OP_LIST
#include "Relativity/RelativityOps.cpp.inc"


int main(int argc, char **argv) {
  mlir::DialectRegistry registry;
  registry.insert<mlir::relativity::RelativityDialect>();
  mlir::registerAllPasses();

  return mlir::asMainReturnCode(
      mlir::MlirOptMain(argc, argv, "Relativity optimizer driver", registry));
}
