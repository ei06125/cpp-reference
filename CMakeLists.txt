# =============================================================================
# General settings
# -----------------------------------------------------------------------------
# Travis (focal) runs on CMake 3.16.2
cmake_minimum_required(VERSION 3.16.2..3.18.2)
include(tools/cmake/LogSystem/Logger.cmake)

# =============================================================================
# Workspace settings
# -----------------------------------------------------------------------------
include(tools/cmake/ConfigureWorkspace.cmake)

# =============================================================================
# Project settings
# -----------------------------------------------------------------------------

# ~~~
# CMAKE_PROJECT_INCLUDE_BEFORE // not working
# Inject custom code into project builds without modifying their source
# set(CMAKE_PROJECT_INCLUDE_BEFORE
#     "${CMAKE_CURRENT_LIST_DIR}/common-project-include.in")
# include("${CMAKE_CURRENT_SOURCE_DIR}/project-meta-info.in")
# ~~~

project(
  CppTemplateProject
  VERSION 1.0.0
  DESCRIPTION "C++ Starter Project Template"
  HOMEPAGE_URL "https://www.example.com"
  LANGUAGES CXX)

# =============================================================================
# External dependencies
# -----------------------------------------------------------------------------
# Load FetchContent module.
include(FetchContent)

# Google Test
option(BUILD_PROJECT_TESTS "Build project tests." ON)
if(BUILD_PROJECT_TESTS)
  add_compile_definitions(_SILENCE_TR1_NAMESPACE_DEPRECATION_WARNING=1)
  logwarn("Generating Test Build System")
  set(CMAKE_PROJECT_INCLUDE_BEFORE
      "${ProjectExternalFolder}/googletest/GoogleTest-helper.cmake")
  include(${ProjectExternalFolder}/googletest/CMakeLists.txt)
  LogTrace("Building project tests - done")
endif()

# =============================================================================
# Compiler settings
# -----------------------------------------------------------------------------
# TODO: Use CMAKE_CXX_KNOWN_FEATURES instead of setting CMAKE_CXX_STANDARD
# https://cmake.org/cmake/help/v3.16/prop_gbl/CMAKE_CXX_KNOWN_FEATURES.html

# =============================================================================
# Target settings
# -----------------------------------------------------------------------------
add_executable(main)
target_sources(main PRIVATE ${ProjectSourceFolder}/main.cpp)
target_compile_features(main PRIVATE cxx_lambda_init_captures cxx_std_17)
target_include_directories(main PUBLIC ${ProjectIncludeFolder})
target_precompile_headers(main PRIVATE ${ProjectIncludeFolder}/stl.hpp)

if(BUILD_PROJECT_TESTS)
  enable_testing()
  add_executable(testing)
  target_sources(testing PRIVATE ${ProjectTestsFolder}/main.test.cpp)
  target_link_libraries(testing gtest_main)
  add_test(NAME factorial COMMAND testing)
endif()
