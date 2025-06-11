cmake_minimum_required(VERSION 3.20)
project(RelativityMLIR LANGUAGES C CXX)

# Passe tout le projet et ses subdirs en C++17
set(CMAKE_CXX_STANDARD     17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS    OFF)   # pas d’extensions GNU
# Configuration LLVM/MLIR
set(LLVM_DIR "/opt/local/libexec/llvm-20/lib/cmake/llvm")
set(MLIR_DIR "/opt/local/libexec/llvm-20/lib/cmake/mlir")

find_package(MLIR REQUIRED CONFIG)
include(${MLIR_CMAKE_DIR}/AddMLIR.cmake)

list(APPEND CMAKE_MODULE_PATH
  "${MLIR_CMAKE_DIR}"
  "${LLVM_CMAKE_DIR}"
)

# Répertoires d'inclusion
include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}/include
  ${CMAKE_BINARY_DIR}/generated/include
  ${MLIR_INCLUDE_DIRS}
)

# Sous-projets
add_subdirectory(lib)
add_subdirectory(tools)
