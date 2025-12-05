set(LLVM_TARGET_DEFINITIONS RelativityDialect.td)
mlir_tablegen(RelativityOpsDialect.h.inc -gen-dialect-decls -dialect=relativity)
mlir_tablegen(RelativityOpsDialect.cpp.inc -gen-dialect-defs -dialect=relativity)
add_public_tablegen_target(MLIRRelativityOpsDialectIncGen)

set(LLVM_TARGET_DEFINITIONS RelativityOps.td)
mlir_tablegen(RelativityOps.h.inc -gen-op-decls)
mlir_tablegen(RelativityOps.cpp.inc -gen-op-defs)
add_public_tablegen_target(MLIRRelativityOpsIncGen)

add_mlir_doc(RelativityDialect RelativityDialect Relativity/ -gen-dialect-doc)
add_mlir_doc(RelativityOps RelativityOps Relativity/ -gen-op-doc)
