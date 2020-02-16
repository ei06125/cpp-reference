message(STATUS "Executing Main ConfigurePreCompiledHeaders")

if(${CMAKE_VERSION} LESS 16)

  add_library(pch ${ProjectIncludeFolder}/pch.hpp)
  target_sources(pch PRIVATE ${ProjectSourceFolder}/pch.cpp)
  target_include_directories(pch PUBLIC ${ProjectIncludeFolder})
  add_custom_command(
    TARGET pch
    POST_BUILD
    COMMAND echo ARGS "Precompiling Headers"
    COMMAND g++ ${ProjectIncludeFolder}/pch.hpp
    COMMAND echo ARGS "Precompiling Headers - done")

  function(target_precompile_headers target scope header)
    add_dependencies(${target} pch)
  endfunction(target_precompile_headers)
endif()
