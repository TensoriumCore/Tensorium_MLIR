add_mlir_dialect_library(RelativityDialect
  RelativityDialect.cpp
  RelativityOps.cpp
  
  Frontend/Parser.cpp
  Utils/MetricExtract.cpp
  Utils/MetricUtils.cpp 

  RelativityLoweringPass.cpp
  AssembleMetricTensorPass.cpp
  RelativitySimplifyPass.cpp
  RelExpandMetricPass.cpp
  RelExtractSpatialPass.cpp
  
  LinearAlgebra/RelLinAlgLowering.cpp
  RelAddCInterfacePass/RelAddCInterfacePass.cpp

  DEPENDS
  MLIRRelativityOpsIncGen
  MLIRRelativityOpsDialectIncGen

  LINK_LIBS PUBLIC
  MLIRIR
  MLIRFuncDialect
  MLIRArithDialect
  MLIRMathDialect
  MLIRSCFDialect
  MLIRVectorDialect
  MLIRTensorDialect
  MLIRLinalgDialect
)

set(LLVM_TARGET_DEFINITIONS ${CMAKE_SOURCE_DIR}/include/Relativity/RelativityOps.td)
mlir_tablegen(RelativityOps.py.inc -gen-python-op-bindings -bind-dialect=relativity)
add_public_tablegen_target(RelativityPythonOpsGen)
