add_mlir_library(RelativityTransforms
  SimplifyDerivs.cpp
  LINK_LIBS PUBLIC
  MLIRRelativity
  MLIRTransformUtils
)
