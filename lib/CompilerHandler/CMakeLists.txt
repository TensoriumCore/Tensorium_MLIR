# find_package(Clang REQUIRED CONFIG)

include_directories(${CLANG_INCLUDE_DIRS})
add_definitions(${CLANG_DEFINITIONS})
add_subdirectory(Backend)
add_subdirectory(Frontend)
