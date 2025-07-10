
add_library(TensoriumTex STATIC
  Parser.cpp
)

target_include_directories(TensoriumTex PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}
)
