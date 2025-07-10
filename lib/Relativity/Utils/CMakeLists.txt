add_library(FormulaParser
    FormulaParser.cpp
)

target_include_directories(FormulaParser
    PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}
)

target_link_libraries(FormulaParser
    PUBLIC
)
