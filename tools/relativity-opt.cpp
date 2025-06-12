#include "mlir/Tools/mlir-opt/MlirOptMain.h"
#include "Relativity/Dialect.h"

int main(int argc, char **argv) {
  mlir::DialectRegistry registry;
  registry.insert<mlir::relativity::RelativityDialect>();  // SEUL dialecte


  return mlir::asMainReturnCode(
      mlir::MlirOptMain(argc, argv, "Relativity-only driver", registry));
}
