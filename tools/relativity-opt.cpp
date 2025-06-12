#include "mlir/Tools/mlir-opt/MlirOptMain.h"
#include "Relativity/Dialect.h"
#define GET_OP_LIST
#include "Relativity/RelativityOps.cpp.inc"
#include "Relativity/RelativityDialect.cpp.inc"

int main(int argc, char **argv) {
  mlir::DialectRegistry registry;

  registry.insert<mlir::relativity::RelativityDialect>();

  return mlir::asMainReturnCode(
      mlir::MlirOptMain(argc, argv,
                        "Relativity optimizer driver", registry));
}

