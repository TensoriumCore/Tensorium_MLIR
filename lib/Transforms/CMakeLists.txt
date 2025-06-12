file(GLOB TRANSFORM_SRCS *.cpp)

add_mlir_library(MLIRRelativityTransforms
  SimplifyDerivs.cpp

  LINK_LIBS PUBLIC
  MLIRIR
  MLIRSupport
)
