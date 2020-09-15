# =============================================================================
# General settings
# -----------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.15..3.18) # Travis runs on CMake 3.12

include("${CMAKE_CURRENT_LIST_DIR}/project-meta-info.in")
project(
  CppTemplateProject
  VERSION ${project_version}
  DESCRIPTION ${project_description}
  HOMEPAGE_URL ${project_homepage}
  LANGUAGES ${project_language})

# =============================================================================
# Compiler settings
# -----------------------------------------------------------------------------
# TODO: Use CMAKE_CXX_KNOWN_FEATURES instead of setting CMAKE_CXX_STANDARD
# https://cmake.org/cmake/help/v3.16/prop_gbl/CMAKE_CXX_KNOWN_FEATURES.html
# set(CMAKE_CXX_STANDARD 11)

# =============================================================================
# Workspace settings
# -----------------------------------------------------------------------------
include(scripts/cmake/ConfigureWorkspace.cmake)
include(scripts/cmake/ConfigurePreCompiledHeaders.cmake)

# =============================================================================
# Target settings
# -----------------------------------------------------------------------------
add_executable(main main.cpp)
target_compile_features(main PRIVATE cxx_lambda_init_captures)
target_include_directories(main PUBLIC ${ProjectIncludeFolder})
target_precompile_headers(main PRIVATE ${ProjectIncludeFolder}/stl.hpp)

enable_testing()
add_executable(tester tester.cpp)
add_test(Tester tester)
