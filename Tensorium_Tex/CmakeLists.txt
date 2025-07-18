
file(GLOB_RECURSE TEX_SRC
    "lib/Frontend/*.cpp"
    "lib/Backend/*.cpp"
    "lib/Utils/*.cpp"
    "srcs/*.cpp"
)
add_executable(tensorium-tex ${TEX_SRC})
target_include_directories(tensorium-tex PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/lib/Frontend
    ${CMAKE_CURRENT_SOURCE_DIR}/lib/Backend
    ${CMAKE_CURRENT_SOURCE_DIR}/lib/Utils
    ${CMAKE_CURRENT_SOURCE_DIR}/lib
    ${CMAKE_CURRENT_SOURCE_DIR}/srcs
)

target_compile_features(tensorium-tex PRIVATE cxx_std_17)
target_compile_options(tensorium-tex PRIVATE -Wall -Wextra -g)

set_target_properties(tensorium-tex PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)

