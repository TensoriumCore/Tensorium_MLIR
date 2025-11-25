find_program(FILECHECK_TOOL FileCheck HINTS ${LLVM_TOOLS_BINARY_DIR})
find_program(COUNT_TOOL count HINTS ${LLVM_TOOLS_BINARY_DIR})
find_program(NOT_TOOL not HINTS ${LLVM_TOOLS_BINARY_DIR})

if(NOT TARGET FileCheck)
  add_custom_target(FileCheck)
endif()

if(NOT TARGET count)
  add_custom_target(count)
endif()

if(NOT TARGET not)
  add_custom_target(not)
endif()
configure_lit_site_cfg(
        ${CMAKE_CURRENT_SOURCE_DIR}/lit.site.cfg.py.in
        ${CMAKE_CURRENT_BINARY_DIR}/lit.site.cfg.py
        MAIN_CONFIG
        ${CMAKE_CURRENT_SOURCE_DIR}/lit.cfg.py
)

set(STANDALONE_OPT_TEST_DEPENDS
        FileCheck count not
        relativity-opt
        )

add_lit_testsuite(check-relativity-opt "Running the standalone-opt regression tests"
        ${CMAKE_CURRENT_BINARY_DIR}
        DEPENDS ${STANDALONE_OPT_TEST_DEPENDS}
        )
set_target_properties(check-relativity-opt PROPERTIES FOLDER "Tests")

add_lit_testsuites(STANDALONE_OPT ${CMAKE_CURRENT_SOURCE_DIR} DEPENDS ${STANDALONE_OPT_TEST_DEPENDS})

add_subdirectory(Relativity)
