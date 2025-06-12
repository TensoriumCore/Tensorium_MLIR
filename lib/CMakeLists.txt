
include(AddLLVM)
include(TableGen)
include(AddMLIR)

set(LLVM_TARGET_DEFINITIONS ${CMAKE_CURRENT_SOURCE_DIR}/../include/Relativity/Ops.td)
set(MLIR_TABLEGEN_OUTPUT_DIR ${CMAKE_BINARY_DIR}/generated/include/Relativity)
file(MAKE_DIRECTORY ${MLIR_TABLEGEN_OUTPUT_DIR})

mlir_tablegen(${MLIR_TABLEGEN_OUTPUT_DIR}/RelativityDialect.h.inc -gen-dialect-decls -dialect=relativity)
mlir_tablegen(${MLIR_TABLEGEN_OUTPUT_DIR}/RelativityDialect.cpp.inc -gen-dialect-defs -dialect=relativity)
mlir_tablegen(${MLIR_TABLEGEN_OUTPUT_DIR}/RelativityOps.h.inc -gen-op-decls -bind-dialect=relativity)
mlir_tablegen(${MLIR_TABLEGEN_OUTPUT_DIR}/RelativityOps.cpp.inc -gen-op-defs -bind-dialect=relativity)

add_public_tablegen_target(MLIRRelativityOpsIncGen DEPENDS RelativityOps.h.inc RelativityOps.cpp.inc)

add_mlir_dialect(RelativityDialect relativity)
add_mlir_dialect_library(MLIRRelativity
  RelativityDialect.cpp
  DEPENDS
    MLIRRelativityDialectIncGen
    MLIRRelativityOpsIncGen
  LINK_LIBS PUBLIC
    MLIRIR
    MLIRSupport
)

