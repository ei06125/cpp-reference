option(ENABLE_UNIT_TESTING "Enable Unit Tests" ON)
option(ENABLE_FUZZING "Enable Fuzzing Builds" OFF)
option(ENABLE_VALGRIND "Enable Valgrind Test Builds" ON)
option(ENABLE_BENCHMARK "Enable Performance Test Builds" ON)

if(ENABLE_UNIT_TESTING)
  message("Building Unit Tests, using Catch V2")
  add_subdirectory(unit_tests)
endif()

if(ENABLE_FUZZING)
  message("Building Fuzz Tests, using fuzzing sanitizer https://www.llvm.org/docs/LibFuzzer.html")
  add_subdirectory(fuzz_tests)
endif()

if(ENABLE_VALGRIND)
  message("Building Valgrind Tests, using Valgrind https://valgrind.org")
  add_subdirectory(memory_tests)
endif()

if(ENABLE_BENCHMARK)
  message("Building Performance Tests, using Gooel Benchmark https://github.com/google/benchmark")
  add_subdirectory(performance_tests)
endif()
