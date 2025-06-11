# lib/CMakeLists.txt

# Charge les macros nécessaires
include(AddLLVM)
include(TableGen)
include(AddMLIR)

# Configuration TableGen
set(LLVM_TARGET_DEFINITIONS ${CMAKE_CURRENT_SOURCE_DIR}/../include/Relativity/Ops.td)
set(MLIR_TABLEGEN_OUTPUT_DIR ${CMAKE_BINARY_DIR}/generated/include/Relativity)
file(MAKE_DIRECTORY ${MLIR_TABLEGEN_OUTPUT_DIR})

# Génération des fichiers avec chemin de sortie explicite
mlir_tablegen(${MLIR_TABLEGEN_OUTPUT_DIR}/RelativityOps.h.inc -gen-op-decls -bind-dialect=relativity)
mlir_tablegen(${MLIR_TABLEGEN_OUTPUT_DIR}/RelativityOps.cpp.inc -gen-op-defs -bind-dialect=relativity)
mlir_tablegen(${MLIR_TABLEGEN_OUTPUT_DIR}/RelativityDialect.h.inc -gen-dialect-decls -dialect=relativity)
mlir_tablegen(${MLIR_TABLEGEN_OUTPUT_DIR}/RelativityDialect.cpp.inc -gen-dialect-defs -dialect=relativity)

# Correction de la cible tablegen
add_public_tablegen_target(MLIRRelativityOpsIncGen DEPENDS RelativityOps.h.inc)

# Dialecte principal
add_mlir_dialect(RelativityDialect relativity)

add_subdirectory(Parser)
add_subdirectory(Conversion)
add_subdirectory(Transforms)

add_mlir_dialect_library(MLIRRelativity
  RelativityDialect.cpp
  
  ADDITIONAL_HEADER_DIRS
  ${CMAKE_CURRENT_SOURCE_DIR}/../include/Relativity
  ${MLIR_TABLEGEN_OUTPUT_DIR}
  
  DEPENDS
  MLIRRelativityOpsIncGen
  
  LINK_LIBS PUBLIC
  MLIRIR
  MLIRParser
  MLIRSupport
  LLVMSupport
)
