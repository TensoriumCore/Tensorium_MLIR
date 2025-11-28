
#include "Relativity/RelativityDialect.h"
#include "mlir-c/IR.h"
#include "mlir/Bindings/Python/PybindAdaptors.h"
#include "mlir/IR/MLIRContext.h"

#include "mlir/InitAllPasses.h"

using namespace mlir;
using namespace mlir::relativity;

namespace mlir::relativity {
std::unique_ptr<mlir::Pass> createLowerRelativityPass();
std::unique_ptr<mlir::Pass> createAssembleMetricTensorPass();
std::unique_ptr<mlir::Pass> createRelativitySimplifyPass();
std::unique_ptr<mlir::Pass> createRelExpandMetricPass();
std::unique_ptr<mlir::Pass> createRelExtractSpatialPass();
std::unique_ptr<mlir::Pass> createRelLinAlgLowerPass();
std::unique_ptr<mlir::Pass> createRelAddCInterfacePass();
} // namespace mlir::relativity

PYBIND11_MODULE(_relativity_ops, m) {
  m.doc() = "Relativity Dialect Python Bindings";

  m.def("register_dialect", [](MlirContext context, bool load) {
    MLIRContext *cppCtx = reinterpret_cast<MLIRContext *>(context.ptr);

    DialectRegistry registry;
    registry.insert<RelativityDialect>();
    cppCtx->appendDialectRegistry(registry);

    if (load)
      cppCtx->getOrLoadDialect<RelativityDialect>();
  });

  m.def("register_passes", []() {
    static bool done = false;
    if (done)
      return;
    done = true;

    mlir::registerAllPasses();

    mlir::registerPass([] { return createLowerRelativityPass(); });
    mlir::registerPass([] { return createAssembleMetricTensorPass(); });
    mlir::registerPass([] { return createRelativitySimplifyPass(); });
    mlir::registerPass([] { return createRelExpandMetricPass(); });
    mlir::registerPass([] { return createRelExtractSpatialPass(); });
    mlir::registerPass([] { return createRelLinAlgLowerPass(); });
    mlir::registerPass([] { return createRelAddCInterfacePass(); });
  });
}
