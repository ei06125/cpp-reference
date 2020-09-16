# =============================================================================
# General settings
# -----------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.16.2) # Travis (focal) runs on CMake 3.16.2
include(cmake/LogSystem/Logger.cmake)

# =============================================================================
# CMAKE_PROJECT_INCLUDE_BEFORE // not working
# -----------------------------------------------------------------------------
# cmake_policy(SET CMP0048 NEW) Inject custom code into project builds without
# modifying their source
# set(CMAKE_PROJECT_INCLUDE_BEFORE
#     "${CMAKE_CURRENT_LIST_DIR}/common-project-include.in")
set(CMAKE_PROJECT_INCLUDE_BEFORE
    "${CMAKE_CURRENT_LIST_DIR}/GoogleTest-helper.cmake")

# include("${CMAKE_CURRENT_SOURCE_DIR}/project-meta-info.in")

# =============================================================================
# Project settings
# -----------------------------------------------------------------------------
project(
  CppTemplateProject
  VERSION 1.0.0
  DESCRIPTION "C++ Starter Project Template"
  HOMEPAGE_URL "https://www.example.com"
  LANGUAGES CXX)

# =============================================================================
# Compiler settings
# -----------------------------------------------------------------------------
# TODO: Use CMAKE_CXX_KNOWN_FEATURES instead of setting CMAKE_CXX_STANDARD
# https://cmake.org/cmake/help/v3.16/prop_gbl/CMAKE_CXX_KNOWN_FEATURES.html
# set(CMAKE_CXX_STANDARD 11)

# Load FetchContent module.
include(FetchContent)

find_package( GTest )

if (NOT GTest_FOUND)
LogWarn("Google Test not found")
else()
LogInfo("Google Test found")
endif()

# Declare GoogleTest as the content to fetch.
FetchContent_Declare(
  googletest
  GIT_REPOSITORY https://github.com/google/googletest.git
  GIT_TAG release-1.8.0)

# Fetch GoogleTest and make build scripts available.
FetchContent_GetProperties(googletest)
if(NOT googletest_POPULATED)
  # Fetch the content using previously declared details.
  FetchContent_Populate(googletest)

  # Custom policies, varaibles and modifications go here. ...
  logwarn("Unsetting CMAKE_PROJECT_INCLUDE_BEFORE temporarily.")
  set(backup_CMAKE_PROJECT_INCLUDE_BEFORE ${CMAKE_PROJECT_INCLUDE_BEFORE})
  unset(CMAKE_PROJECT_INCLUDE_BEFORE)

  # Bring the populated content into the build.
  add_subdirectory(${googletest_SOURCE_DIR} ${googletest_BINARY_DIR})
endif()

# =============================================================================
# CMAKE_PROJECT_<project-name>_INCLUDE_BEFORE // available from CMake 3.17
# -----------------------------------------------------------------------------
logwarn("CMAKE_PROJECT_googletest-distribution_INCLUDE_BEFORE")
set(CMAKE_PROJECT_googletest-distribution_INCLUDE_BEFORE
    "${CMAKE_CURRENT_LIST_DIR}/GoogleTest-helper.cmake")
logwarn("CMAKE_PROJECT_googletest_INCLUDE_BEFORE")
set(CMAKE_PROJECT_googletest_INCLUDE_BEFORE
    "${CMAKE_CURRENT_LIST_DIR}/GoogleTest-helper.cmake")
logwarn("CMAKE_PROJECT_googletest-src_INCLUDE_BEFORE")
set(CMAKE_PROJECT_googletest-src_INCLUDE_BEFORE
    "${CMAKE_CURRENT_LIST_DIR}/GoogleTest-helper.cmake")
logwarn("CMAKE_PROJECT_gtest_INCLUDE_BEFORE")
set(CMAKE_PROJECT_gtest_INCLUDE_BEFORE
    "${CMAKE_CURRENT_LIST_DIR}/GoogleTest-helper.cmake")
# Set default value for policy CMP0048 which will be used by GoogleTest's
# CMakeLists.txt scripts
set(CMAKE_POLICY_DEFAULT_CMP0048 NEW)

# Unset CMAKE_PROJECT_INCLUDE_BEFORE temporarily.
set(backup_CMAKE_PROJECT_INCLUDE_BEFORE ${CMAKE_PROJECT_INCLUDE_BEFORE})
unset(CMAKE_PROJECT_INCLUDE_BEFORE)
set(CMAKE_PROJECT_INCLUDE_BEFORE
    "${CMAKE_CURRENT_LIST_DIR}/GoogleTest-helper.cmake")

logtrace("FetchContent_MakeAvailable(googletest)")
FetchContent_MakeAvailable(googletest)

# Restore CMAKE_PROJECT_INCLUDE_BEFORE again.
logwarn("Restoring CMAKE_PROJECT_INCLUDE_BEFORE again.")
unset(CMAKE_PROJECT_INCLUDE_BEFORE)
set(CMAKE_PROJECT_INCLUDE_BEFORE ${backup_CMAKE_PROJECT_INCLUDE_BEFORE})
unset(backup_CMAKE_PROJECT_INCLUDE_BEFORE)

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
