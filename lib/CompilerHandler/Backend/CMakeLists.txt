
cmake_minimum_required(VERSION 3.13)
project(DumpTensoriumGpuFuncsPass LANGUAGES C CXX)

# Trouve LLVM et Clang
find_package(LLVM REQUIRED CONFIG)
find_package(Clang REQUIRED CONFIG)

list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

add_library(DumpTensoriumGpuFuncsPass SHARED DumpTensoriumGpuFuncs.cpp)

# Utiliser les targets CMake officielles
target_link_libraries(DumpTensoriumGpuFuncsPass PRIVATE
  LLVMCore
  LLVMSupport
  LLVMIRReader
  clang-cpp
)

set_target_properties(DumpTensoriumGpuFuncsPass PROPERTIES
  LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
)

