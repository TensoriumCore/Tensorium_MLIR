
function(add_relativity_execution_test)
  set(options "")
  set(oneValueArgs NAME SRC MLIR_SRC)
  set(multiValueArgs PIPELINE_FLAGS)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  set(TEST_NAME "Test_${ARG_NAME}")
  set(EXEC_NAME "${CMAKE_CURRENT_BINARY_DIR}/${ARG_NAME}")
  set(LOWERED_MLIR "${CMAKE_CURRENT_BINARY_DIR}/${ARG_NAME}.lowered.mlir")
  set(LLVM_IR "${CMAKE_CURRENT_BINARY_DIR}/${ARG_NAME}.ll")
  set(OBJ_FILE "${CMAKE_CURRENT_BINARY_DIR}/${ARG_NAME}.o")


  add_custom_command(
    OUTPUT ${LOWERED_MLIR}
    COMMAND relativity-opt ${ARG_MLIR_SRC} ${ARG_PIPELINE_FLAGS} -o ${LOWERED_MLIR}
    DEPENDS relativity-opt ${ARG_MLIR_SRC}
    COMMENT "Optimizing/Lowering ${ARG_NAME}..."
  )


  add_custom_command(
    OUTPUT ${LLVM_IR}
    COMMAND mlir-translate --mlir-to-llvmir ${LOWERED_MLIR} -o ${LLVM_IR}
    DEPENDS ${LOWERED_MLIR}
    COMMENT "Translating ${ARG_NAME} to LLVM IR..."
  )



  add_custom_command(
    OUTPUT ${EXEC_NAME}
    COMMAND ${CMAKE_CXX_COMPILER} -c ${LLVM_IR} -o ${OBJ_FILE} -O3
    COMMAND ${CMAKE_CXX_COMPILER} ${ARG_SRC} ${OBJ_FILE} -o ${EXEC_NAME} -lm -O3 -std=c++17
    DEPENDS ${LLVM_IR} ${ARG_SRC}
    COMMENT "Compiling and Linking ${ARG_NAME}..."
  )


  add_custom_target(Build_${TEST_NAME} ALL DEPENDS ${EXEC_NAME})


  add_test(NAME ${TEST_NAME} COMMAND ${EXEC_NAME})
endfunction()

set(GRID_PIPELINE_FLAGS
  --rel-expand-metric
  --convert-tensor-to-linalg
  --one-shot-bufferize="bufferize-function-boundaries"
  --convert-linalg-to-loops
  --convert-bufferization-to-memref
  --expand-strided-metadata
  --lower-affine
  --convert-scf-to-cf
  --finalize-memref-to-llvm
  --llvm-request-c-wrappers
  --convert-func-to-llvm
  --convert-cf-to-llvm
  --convert-vector-to-llvm
  --convert-math-to-llvm
  --convert-arith-to-llvm
  --reconcile-unrealized-casts
)

add_relativity_execution_test(
  NAME "GridMetricTest"
  MLIR_SRC "${CMAKE_CURRENT_SOURCE_DIR}/test_grid.mlir"
  SRC "${CMAKE_CURRENT_SOURCE_DIR}/test_grid_cpp.cpp"
  PIPELINE_FLAGS ${GRID_PIPELINE_FLAGS}
)
