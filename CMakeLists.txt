cmake_minimum_required(VERSION 3.16.2..3.18.2)

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

include(tools/cmake/ConfigureWorkspace.cmake)
include(${ProjectCMakeFolder}/StandardProjectSettings.cmake)
include(${ProjectCMakeFolder}/PreventInSourceBuilds.cmake)


# Link this 'library' to set the c++ standard / compile-time options requested
add_library(project_options INTERFACE)
target_compile_features(project_options INTERFACE cxx_std_17)
# Use CMAKE_CXX_KNOWN_FEATURES instead of setting CMAKE_CXX_STANDARD
# https://cmake.org/cmake/help/v3.16/prop_gbl/CMAKE_CXX_KNOWN_FEATURES.html


# Link this 'library' to use the warnings specified in CompilerWarnings.cmake
add_library(project_warnings INTERFACE)

# enable cache system
include(${ProjectCMakeFolder}/Cache.cmake)

# standard compiler warnings
include(${ProjectCMakeFolder}/CompilerWarnings.cmake)
set_project_warnings(project_warnings)

# sanitizer options if supported by compiler
include(${ProjectCMakeFolder}/Sanitizers.cmake)
enable_sanitizers(project_options)

# enable doxygen
include(${ProjectCMakeFolder}/Doxygen.cmake)
enable_doxygen()

# allow for static analysis options
include(${ProjectCMakeFolder}/StaticAnalyzers.cmake)

option(BUILD_SHARED_LIBS "Enable compilation of shared libraries" OFF)
option(ENABLE_TESTING "Enable Test Builds" ON)
option(ENABLE_FUZZING "Enable Fuzzing Builds" OFF)

# Very basic PCH example
option(ENABLE_PCH "Enable Precompiled Headers" ON)
if(ENABLE_PCH)
  # This sets a global PCH parameter, each project will build its own PCH, which is a good idea if any #define's change
  #
  # consider breaking this out per project as necessary
  target_precompile_headers(
    project_options
    INTERFACE
     ${ProjectSourceFolder}/standard_template_library.hpp)
  # target_precompile_headers(
  #   project_options
  #   INTERFACE
  #   <vector>
  #   <string>
  #   <map>
  #   <utility>)
endif()

# Set up some extra Conan dependencies based on our needs before loading Conan
set(CONAN_EXTRA_REQUIRES "")
set(CONAN_EXTRA_OPTIONS "")

if(CPP_STARTER_USE_IMGUI)
  set(CONAN_EXTRA_REQUIRES ${CONAN_EXTRA_REQUIRES} imgui-sfml/2.1@bincrafters/stable)

  # set(CONAN_EXTRA_OPTIONS ${CONAN_EXTRA_OPTIONS} sfml:shared=False sfml:graphics=True sfml:audio=False
  # sfml:window=True libalsa:disable_python=True)
endif()

if(CPP_STARTER_USE_SDL)
  set(CONAN_EXTRA_REQUIRES ${CONAN_EXTRA_REQUIRES} sdl2/2.0.10@bincrafters/stable)
  # set(CONAN_EXTRA_OPTIONS ${CONAN_EXTRA_OPTIONS} sdl2:wayland=True)
endif()

include(${ProjectCMakeFolder}/Conan.cmake)
run_conan()

if(ENABLE_TESTING)
  enable_testing()
  message("Building Tests. Be sure to check out test/constexpr_tests for constexpr testing")
  add_subdirectory(${ProjectTestsFolder})
endif()

add_subdirectory(${ProjectSourceFolder})

option(ENABLE_UNITY "Enable Unity builds of projects" OFF)
if(ENABLE_UNITY)
  # Add for any project you want to apply unity builds for
  set_target_properties(intro PROPERTIES UNITY_BUILD ON)
endif()


# # Load FetchContent module.
# include(FetchContent)

# # Google Test
# option(BUILD_PROJECT_TESTS "Build project tests." ON)
# if(BUILD_PROJECT_TESTS)
#   add_compile_definitions(_SILENCE_TR1_NAMESPACE_DEPRECATION_WARNING=1)
#   logwarn("Generating Test Build System")
#   set(CMAKE_PROJECT_INCLUDE_BEFORE
#       "${ProjectExternalFolder}/googletest/GoogleTest-helper.cmake")
#   include(${ProjectExternalFolder}/googletest/CMakeLists.txt)
#   logtrace("Building project tests - done")
# endif()


# add_executable(main)
# target_sources(main PRIVATE ${ProjectSourceFolder}/main.cpp)
# target_compile_features(main PRIVATE cxx_lambda_init_captures cxx_std_17)
# target_include_directories(main PUBLIC ${ProjectIncludeFolder})
# target_precompile_headers(main PRIVATE ${ProjectIncludeFolder}/stl.hpp)

# if(BUILD_PROJECT_TESTS)
#   enable_testing()
#   add_executable(testing)
#   target_sources(testing PRIVATE ${ProjectTestsFolder}/main.test.cpp)
#   target_link_libraries(testing gtest_main)
#   add_test(NAME factorial COMMAND testing)
# endif()
