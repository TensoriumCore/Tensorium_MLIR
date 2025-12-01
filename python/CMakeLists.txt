cmake_minimum_required(VERSION 3.15)

find_package(Python3 COMPONENTS Interpreter Development REQUIRED)
find_package(pybind11 REQUIRED)
find_package(MLIR REQUIRED CONFIG)

set(PKG_ROOT "${CMAKE_CURRENT_BINARY_DIR}/Tensorium")
set(PKG_DIALECTS "${PKG_ROOT}/dialects")

file(MAKE_DIRECTORY "${PKG_ROOT}")
file(MAKE_DIRECTORY "${PKG_DIALECTS}")

file(COPY "${CMAKE_CURRENT_SOURCE_DIR}/Tensorium" DESTINATION "${CMAKE_CURRENT_BINARY_DIR}")

include_directories(
  ${pybind11_INCLUDE_DIRS}
  ${PROJECT_SOURCE_DIR}/include
  ${MLIR_INCLUDE_DIRS}
)

add_library(TensoriumRuntime MODULE RuntimeBinding.cpp)

set_target_properties(TensoriumRuntime PROPERTIES 
  PREFIX ""
  OUTPUT_NAME "_tensorium_runtime"
  LIBRARY_OUTPUT_DIRECTORY "${PKG_DIALECTS}" 
  CXX_VISIBILITY_PRESET "hidden"
)

target_link_libraries(TensoriumRuntime PRIVATE pybind11::module)

add_library(RelativityCompilerBindings MODULE RelativityModule.cpp)

set_target_properties(RelativityCompilerBindings PROPERTIES 
  PREFIX ""
  OUTPUT_NAME "_relativity_ops"
  LIBRARY_OUTPUT_DIRECTORY "${PKG_DIALECTS}" 
)

set(MLIR_PYTHON_LIB_DIR "/opt/local/libexec/llvm-20/python_packages/mlir_core/mlir/_mlir_libs")
target_link_directories(RelativityCompilerBindings PRIVATE ${MLIR_PYTHON_LIB_DIR})

target_link_libraries(RelativityCompilerBindings
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
  target_link_options(RelativityCompilerBindings PRIVATE
    "-Wl,-force_load,$<TARGET_FILE:MLIRRelativity>"
    "-Wl,-rpath,${MLIR_PYTHON_LIB_DIR}"
    "-Wl,-rpath,${PROJECT_BINARY_DIR}/lib"
  )
endif()
set(ODS_COMMON_PY "${PKG_DIALECTS}/_ods_common.py")
file(WRITE "${ODS_COMMON_PY}" "
from mlir.dialects._ods_common import *
from mlir.dialects._ods_common import _cext
")
set(REL_PY_INC "${PROJECT_BINARY_DIR}/lib/Relativity/RelativityOps.py.inc")
set(REL_PY_OUT "${PKG_DIALECTS}/_relativity_ops_gen.py")

add_custom_command(
  OUTPUT ${REL_PY_OUT}
  DEPENDS RelativityPythonOpsGen
  COMMAND ${CMAKE_COMMAND} -E copy_if_different ${REL_PY_INC} ${REL_PY_OUT}
)

add_custom_target(RelativityPythonGenerated DEPENDS ${REL_PY_OUT})
add_dependencies(RelativityCompilerBindings RelativityPythonGenerated)
