
find_package(MLIR REQUIRED CONFIG)      # fourni par votre build LLVM

add_executable(relativity-opt relativity-opt.cpp)

target_link_libraries(relativity-opt
  PRIVATE
  MLIRRelativity
  MLIRIR
  MLIROptLib
  MLIRParser
  MLIRPass
  MLIRTransforms
  MLIRSupport
)

