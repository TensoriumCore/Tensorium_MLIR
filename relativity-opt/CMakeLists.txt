get_property(dialect_libs GLOBAL PROPERTY MLIR_DIALECT_LIBS)
get_property(conversion_libs GLOBAL PROPERTY MLIR_CONVERSION_LIBS)
include_directories(${LLVM_INCLUDE_DIRS})

set(LIBS
        ${dialect_libs}
        ${conversion_libs}
        MLIROptLib
        RelativityDialect 
        MLIRTensorDialect
        MLIRFuncDialect
        MLIRMathDialect
        MLIRArithDialect
        MLIRAffineDialect
        )

add_llvm_executable(relativity-opt relativity-opt.cpp)
llvm_update_compile_flags(relativity-opt)
target_link_libraries(relativity-opt PRIVATE ${LIBS})
