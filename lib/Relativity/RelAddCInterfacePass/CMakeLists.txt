add_library(MLIRRelAddCInterfacePass
  RelAddCInterfacePass.cpp
)

target_link_libraries(MLIRRelAddCInterfacePass
  PRIVATE
    MLIRFuncDialect
    MLIRIR
    MLIRPass
)
