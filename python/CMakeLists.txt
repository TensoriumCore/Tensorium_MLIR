find_package(Python3 COMPONENTS Interpreter Development REQUIRED)
find_package(pybind11 REQUIRED)
find_package(MLIR REQUIRED CONFIG)

add_library(RelativityPythonBindings MODULE RelativityModule.cpp)

set_target_properties(RelativityPythonBindings PROPERTIES 
  PREFIX ""
  OUTPUT_NAME "_relativity_ops"
  LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/mlir/dialects"
)

target_include_directories(RelativityPythonBindings PRIVATE 
  ${pybind11_INCLUDE_DIRS}
  ${PROJECT_SOURCE_DIR}/include
  ${MLIR_INCLUDE_DIRS}
)

set(MLIR_PYTHON_LIB_DIR
  "/opt/local/libexec/llvm-20/python_packages/mlir_core/mlir/_mlir_libs"
)

target_link_directories(RelativityPythonBindings PRIVATE
  ${MLIR_PYTHON_LIB_DIR}
)

target_link_libraries(RelativityPythonBindings
  PRIVATE
    ${MLIR_PYTHON_LIB_DIR}/libMLIRPythonCAPI.dylib
    MLIRRelativity
	MLIRRelAddCInterfacePass
    MLIRCAPIIR
    MLIRBytecodeWriter
    MLIRBytecodeOpInterface
    MLIRParser
    MLIRBytecodeReader
    MLIRAsmParser
    MLIRPass
    MLIRAnalysis
    MLIRCallInterfaces
    MLIRControlFlowInterfaces
    MLIRDataLayoutInterfaces
    MLIRInferIntRangeInterface
    MLIRLoopLikeInterface
    MLIRFunctionInterfaces
    MLIRPresburger
    MLIRSideEffectInterfaces
    MLIRViewLikeInterface
)

if(APPLE)
  target_link_options(RelativityPythonBindings PRIVATE
    "-Wl,-force_load,$<TARGET_FILE:MLIRRelativity>"
    "-Wl,-rpath,${MLIR_PYTHON_LIB_DIR}"
    "-Wl,-rpath,${PROJECT_BINARY_DIR}/lib"
  )
endif()

set(REL_PY_INC "${PROJECT_BINARY_DIR}/lib/Relativity/RelativityOps.py.inc")
set(MLIR_DIALECTS_DIR "${CMAKE_CURRENT_BINARY_DIR}/mlir/dialects")
file(MAKE_DIRECTORY "${MLIR_DIALECTS_DIR}")

set(REL_PY_OUT "${MLIR_DIALECTS_DIR}/_relativity_ops_gen.py")

add_custom_command(
  OUTPUT ${REL_PY_OUT}
  DEPENDS RelativityPythonOpsGen
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
          ${REL_PY_INC} ${REL_PY_OUT}
)

add_custom_target(RelativityPythonGenerated DEPENDS ${REL_PY_OUT})
add_dependencies(RelativityPythonBindings RelativityPythonGenerated)

add_custom_command(
  TARGET RelativityPythonBindings PRE_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
          ${CMAKE_CURRENT_SOURCE_DIR}/mlir/dialects/relativity.py
          ${MLIR_DIALECTS_DIR}/relativity.py
)
