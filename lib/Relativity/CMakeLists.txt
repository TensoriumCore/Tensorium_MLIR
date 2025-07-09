add_mlir_dialect_library(MLIRRelativity
        RelativityDialect.cpp
        RelativityOps.cpp
		RelativityLoweringPass.cpp

        ADDITIONAL_HEADER_DIRS
        ${PROJECT_SOURCE_DIR}/include/Relativity

        DEPENDS
        MLIRRelativityOpsIncGen

	LINK_LIBS PUBLIC
	MLIRIR
        MLIRInferTypeOpInterface
	)
