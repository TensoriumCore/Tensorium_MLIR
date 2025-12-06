# 1. On définit les composants LLVM dont on a besoin AVANT de créer l'exécutable
# Cela résout les erreurs "llvm::LLVMContext", "llvm::Module", etc.
set(LLVM_LINK_COMPONENTS
  Core
  Support
  AsmParser
  Target
  BitReader
  BitWriter
)

add_llvm_executable(tensorium-tex tensorium-tex/tensorium-tex.cpp)

# 2. Récupération des groupes de librairies MLIR
get_property(conversion_libs GLOBAL PROPERTY MLIR_CONVERSION_LIBS)
get_property(dialect_libs GLOBAL PROPERTY MLIR_DIALECT_LIBS)
get_property(translation_libs GLOBAL PROPERTY MLIR_TRANSLATION_LIBS)

# 3. Liaison complète
target_link_libraries(tensorium-tex
  PRIVATE
  RelativityDialect
  
  # Groupes globaux
  ${conversion_libs}
  ${dialect_libs}
  ${translation_libs}

  # Enregistrements et Traductions (Crucial pour le "Translation failed")
  MLIRToLLVMIRTranslationRegistration 
  MLIRTargetLLVMIRExport

  # Core MLIR (Résout PassManager, Canonicalizer, etc.)
  MLIRIR
  MLIRPass
  MLIRTransforms
  MLIRSupport
  MLIRParser
  MLIRBytecodeWriter
  MLIRExecutionEngine
)
