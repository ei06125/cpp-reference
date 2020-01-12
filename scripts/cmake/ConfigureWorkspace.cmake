message(STATUS "Executing Main ConfigureWorkspace.cmake")

# =============================================================================
# Root Folders
# -----------------------------------------------------------------------------
set(ProjectRootFolder ${PROJECT_SOURCE_DIR})
set(CMakeScriptsRootFolder ${CMAKE_CURRENT_LIST_DIR})


# =============================================================================
# Output Folders
# -----------------------------------------------------------------------------
set(ProjectOutputFolder ${ProjectRootFolder}/output)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${ProjectOutputFolder})
# set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${ProjectOutputFolder})
#set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${ProjectOutputFolder})
