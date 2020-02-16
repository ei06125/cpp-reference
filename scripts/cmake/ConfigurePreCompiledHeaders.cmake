message(STATUS "Executing Main ConfigurePreCompiledHeaders")

if(${CMAKE_VERSION} LESS 16)

  add_library(pch ${ProjectSourceFolder}/pch.cpp)
  target_include_directories(pch PUBLIC ${ProjectIncludeFolder})
  if(MSVC)
    add_custom_command(
      TARGET pch
      POST_BUILD
      COMMAND cl /c /permissive- /W3  /I ${ProjectIncludeFolder} /Yc"pch.hpp" ${ProjectSourceFolder}/pch.cpp)
  else()
    add_custom_command(
      TARGET pch
      POST_BUILD
      COMMAND g++ ${ProjectIncludeFolder}/pch.hpp)
  endif()

  function(target_precompile_headers target scope header)
    add_dependencies(${target} pch)
  endfunction(target_precompile_headers)
endif()
