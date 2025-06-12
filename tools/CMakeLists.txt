
add_executable(relativity-opt relativity-opt.cpp)


target_link_libraries(relativity-opt
  PRIVATE
  MLIRRelativityDialect
  MLIRParser
  MLIRIR
  MLIRPass
  MLIRBytecodeReader
  MLIRAsmParser
  MLIRSupport
  MLIRAnalysis
)

