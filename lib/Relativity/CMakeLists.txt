add_mlir_dialect_library(MLIRRelativity
        RelativityDialect.cpp
        RelativityOps.cpp
		RelativityLoweringPass.cpp
		RelativitySimplifyPass.cpp
		AssembleMetricTensorPass.cpp
		Utils/FormulaParser.cpp
		RelExpandMetricPass.cpp

        ADDITIONAL_HEADER_DIRS
        ${PROJECT_SOURCE_DIR}/include/Relativity

        DEPENDS
        MLIRRelativityOpsIncGen

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

# add_subdirectory(Utils)
