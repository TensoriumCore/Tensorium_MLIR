
# lib/Conversion/CMakeLists.txt

# Génère la librairie de conversion MLIR
add_mlir_conversion_library(MLIRRelativityConversion
  ASTToMLIR.cpp

  DEPENDS
    MLIRRelativityOpsIncGen

  LINK_LIBS PUBLIC
    MLIRIR
    MLIRParser
    MLIRSupport
    ${llvm_libs}
)
