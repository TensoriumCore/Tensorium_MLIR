
find_package(MLIR REQUIRED CONFIG)   

add_executable(relativity-opt relativity-opt.cpp)

target_link_libraries(relativity-opt
  PRIVATE
  MLIRRelativity
	MLIRFuncDialect
	MLIRArithDialect 
	MLIRTensorDialect
	MLIRSCFDialect
	MLIRMemRefDialect  
	MLIRMathDialect
  MLIRIR
  MLIROptLib
  MLIRParser
  MLIRPass
  MLIRTransforms
  MLIRSupport
  MLIRSideEffectInterfaces
)

