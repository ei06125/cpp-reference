find_package(GTest QUIET)

if(GTest_FOUND)
  # cmake-format: off
  # Make found targets globally available
  set_target_properties(
      ${gtest}
      ${gtest_main}
      ${gmock}
      ${gmock_main}
      PROPERTIES IMPORTED_GLOBAL TRUE)
    # cmake-format: on
else()
  logwarn("Downloading Google Test...")
endif()
  include(${ProjectExternalFolder}/googletest/GoogleTest-helper.cmake)

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

    # Bring the populated content into the build.
    add_subdirectory(${googletest_SOURCE_DIR} ${googletest_BINARY_DIR}
                     EXCLUDE_FROM_ALL)
  endif()

  FetchContent_MakeAvailable(googletest)

# endif()
