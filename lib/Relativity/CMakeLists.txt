add_mlir_dialect_library(MLIRRelativity
        RelativityDialect.cpp
        RelativityOps.cpp
		RelativityLoweringPass.cpp
		RelativitySimplifyPass.cpp
		AssembleMetricTensorPass.cpp
		Utils/FormulaParser.cpp

        ADDITIONAL_HEADER_DIRS
        ${PROJECT_SOURCE_DIR}/include/Relativity

        DEPENDS
        MLIRRelativityOpsIncGen

	LINK_LIBS PUBLIC
	MLIRIR
        MLIRInferTypeOpInterface
	)

# add_subdirectory(Utils)
