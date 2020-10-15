# Add your performance tests here. These are going to rely on Google Benchmark.

add_executable(performance_tester performance_tester.cpp)
target_link_libraries(performance_tester PRIVATE project_options project_warnings CONAN_PKG::benchmark)
add_test(NAME performance_tester_run COMMAND performance_tester)

add_executable(push_back_tester push_back_tester.cpp)
target_link_libraries(push_back_tester PRIVATE project_options project_warnings CONAN_PKG::benchmark)
add_test(NAME push_back_tester_run COMMAND push_back_tester)

add_executable(fastmod_tester fastmod_tester.cpp)
target_link_libraries(fastmod_tester PRIVATE project_options project_warnings CONAN_PKG::benchmark)
add_test(NAME fastmod_tester_run COMMAND fastmod_tester)