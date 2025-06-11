add_mlir_tool(relativity-opt relativity-opt.cpp)

target_link_libraries(relativity-opt PRIVATE
  MLIRRelativity
  MLIRRelativityTransforms
  MLIRPass
  MLIRParser
  MLIRIR
)
