include(AddLLVM)
include(TableGen)
include(AddMLIR)

set(MLIR_TABLEGEN_OUTPUT_DIR ${CMAKE_BINARY_DIR}/generated/include/Relativity)
file(MAKE_DIRECTORY ${MLIR_TABLEGEN_OUTPUT_DIR})

set(LLVM_TARGET_DEFINITIONS ${PROJECT_SOURCE_DIR}/include/Relativity/Ops.td)

mlir_tablegen(${MLIR_TABLEGEN_OUTPUT_DIR}/RelativityDialect.h.inc  -gen-dialect-decls -dialect=relativity)
mlir_tablegen(${MLIR_TABLEGEN_OUTPUT_DIR}/RelativityDialect.cpp.inc -gen-dialect-defs  -dialect=relativity)
add_public_tablegen_target(MLIRRelativityDialectIncGen
  DEPENDS RelativityDialect.h.inc RelativityDialect.cpp.inc)

mlir_tablegen(${MLIR_TABLEGEN_OUTPUT_DIR}/RelativityOps.h.inc  -gen-op-decls  -bind-dialect=relativity)
mlir_tablegen(${MLIR_TABLEGEN_OUTPUT_DIR}/RelativityOps.cpp.inc -gen-op-defs   -bind-dialect=relativity)
add_public_tablegen_target(MLIRRelativityOpsIncGen
  DEPENDS RelativityOps.h.inc RelativityOps.cpp.inc)

mlir_tablegen(${MLIR_TABLEGEN_OUTPUT_DIR}/RelativityTypes.h.inc -gen-typedef-decls -dialect=relativity)
mlir_tablegen(${MLIR_TABLEGEN_OUTPUT_DIR}/RelativityTypes.cpp.inc -gen-typedef-defs -dialect=relativity)
add_public_tablegen_target(MLIRRelativityTypesIncGen
  DEPENDS RelativityTypes.h.inc RelativityTypes.cpp.inc)

add_mlir_dialect_library(MLIRRelativity
  RelativityDialect.cpp
  RelativityOps.cpp  
  ADDITIONAL_HEADER_DIRS
    ${PROJECT_SOURCE_DIR}/include/Relativity

  DEPENDS
    MLIRRelativityDialectIncGen
    MLIRRelativityOpsIncGen
    MLIRRelativityTypesIncGen 

  LINK_LIBS PUBLIC
    MLIRIR
    MLIRParser
    MLIRSupport
)
