# Add your performance tests here. These are going to rely on Google Benchmark.

add_executable(performance_tester performance_tester.cpp)
target_link_libraries(performance_tester PRIVATE project_options project_warnings CONAN_PKG::benchmark)

add_test(NAME performance_tester_run COMMAND performance_tester)
