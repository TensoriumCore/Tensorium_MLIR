cmake_minimum_required(VERSION 3.13)
project(DumpTensoriumGpuFuncsPass LANGUAGES C CXX)
find_package(LLVM REQUIRED CONFIG)
list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

add_library(DumpTensoriumGpuFuncsPass SHARED DumpTensoriumGpuFuncs.cpp)

llvm_map_components_to_libnames(LLVM_LIBS Core Support Passes)
target_link_libraries(DumpTensoriumGpuFuncsPass PRIVATE ${LLVM_LIBS})

set_target_properties(DumpTensoriumGpuFuncsPass PROPERTIES
  LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
)
set_target_properties(DumpTensoriumGpuFuncsPass PROPERTIES
    COMPILE_FLAGS "-fno-rtti"
)
