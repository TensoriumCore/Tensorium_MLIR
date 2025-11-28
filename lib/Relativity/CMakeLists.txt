add_mlir_dialect_library(MLIRRelativity
  RelativityDialect.cpp
  RelativityOps.cpp
  RelativityLoweringPass.cpp
  RelativitySimplifyPass.cpp
  AssembleMetricTensorPass.cpp
  Utils/FormulaParser.cpp
  RelExpandMetricPass.cpp
  RelExtractSpatialPass.cpp
  LinearAlgebra/RelLinAlgLowering.cpp

  ADDITIONAL_HEADER_DIRS
  ${PROJECT_SOURCE_DIR}/include/Relativity

  DEPENDS
  MLIRRelativityOpsIncGen
  RelativityPythonOpsGen

  LINK_LIBS PUBLIC
  MLIRIR
  MLIRInferTypeOpInterface
)

target_sources(MLIRRelativity PRIVATE
  ${CMAKE_SOURCE_DIR}/Tensorium_Tex/lib/Frontend/Parser.cpp
)

target_include_directories(MLIRRelativity PRIVATE
  ${CMAKE_SOURCE_DIR}/Tensorium_Tex/lib/Frontend
)

set(LLVM_TARGET_DEFINITIONS ${CMAKE_SOURCE_DIR}/include/Relativity/RelativityOps.td)

mlir_tablegen(RelativityOps.py.inc -gen-python-op-bindings -bind-dialect=relativity)
add_public_tablegen_target(RelativityPythonOpsGen)

add_subdirectory(LinearAlgebra)
add_subdirectory(RelAddCInterfacePass)
