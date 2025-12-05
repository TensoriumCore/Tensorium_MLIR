add_llvm_executable(tensorium-tex tensorium-tex/tensorium-tex.cpp)

target_link_libraries(tensorium-tex
  PRIVATE
  RelativityDialect
  MLIRIR
  MLIRFuncDialect
  MLIRSupport
)
