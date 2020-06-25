# =============================================================================
# General settings
# -----------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.16)
project(CppTemplateProject)

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
