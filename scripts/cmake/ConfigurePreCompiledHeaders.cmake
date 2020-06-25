message(STATUS "Executing Main ConfigurePreCompiledHeaders")

if(${CMAKE_VERSION} LESS 16)
  function(target_precompile_headers target scope header)
  
    get_filename_component(pch ${header} NAME_WE)
    message(STATUS "pch: ${pch}")
    add_library(${pch} ${ProjectIncludeFolder}/${pch}.cpp)
    target_include_directories(${pch} PUBLIC ${ProjectIncludeFolder})

    if(MSVC)
      add_custom_command(
        TARGET ${pch}
        POST_BUILD
        COMMAND cl /c /permissive- /W3  /I ${ProjectIncludeFolder} /Yc"${pch}.hpp" ${ProjectIncludeFolder}/${pch}.cpp)
    else()
      add_custom_command(
        TARGET ${pch}
        POST_BUILD
        COMMAND g++ -std=c++11 ${ProjectIncludeFolder}/${pch}.hpp)
    endif()

    add_dependencies(${target} ${pch})

  endfunction(target_precompile_headers)
endif()
