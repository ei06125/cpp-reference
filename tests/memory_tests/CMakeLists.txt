add_executable(mem_tester mem_tester.cpp)
# Add -O0 to remove optimizations when using gcc
IF(CMAKE_COMPILER_IS_GNUCC)
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O0")
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0")
ENDIF(CMAKE_COMPILER_IS_GNUCC)

target_link_libraries( mem_tester PRIVATE project_options project_warnings)
add_test(NAME mem_tester_run COMMAND mem_tester)
