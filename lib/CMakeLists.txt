
include(AddLLVM)
include(TableGen)
include(AddMLIR)

set(LLVM_TARGET_DEFINITIONS
    ${CMAKE_CURRENT_SOURCE_DIR}/../include/Relativity/Ops.td)

mlir_tablegen(RelativityOps.h.inc  -gen-op-decls -bind-dialect=relativity)
mlir_tablegen(RelativityOps.cpp.inc -gen-op-defs   -bind-dialect=relativity)
add_public_tablegen_target(MLIRRelativityOpsIncGen
  DEPENDS RelativityOps.h.inc RelativityOps.cpp.inc)

add_mlir_dialect(RelativityDialect relativity)

add_subdirectory(Transforms)

