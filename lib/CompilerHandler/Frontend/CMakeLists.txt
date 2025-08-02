add_library(TensoriumPragmaPlugin SHARED
  PragmaHandler.cpp
)

target_include_directories(TensoriumPragmaPlugin
  PRIVATE
    ${LLVM_INCLUDE_DIRS}
    ${MLIR_INCLUDE_DIRS}
    ${CMAKE_CURRENT_SOURCE_DIR}/../../include
)

# ► Une seule ligne pour tout Clang (+ OpenMP IR builder)
target_link_libraries(TensoriumPragmaPlugin
  PRIVATE
    clang-cpp  
    LLVMFrontendOpenMP
)

set_target_properties(TensoriumPragmaPlugin PROPERTIES
  LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
  OUTPUT_NAME "TensoriumPragmaPlugin"
)
