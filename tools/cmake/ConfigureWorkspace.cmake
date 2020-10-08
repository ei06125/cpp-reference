# =============================================================================
# § Top-Level Directories
# -----------------------------------------------------------------------------
# For more information: https://api.csswg.org/bikeshed/?force=1&url=https://raw.
# githubusercontent.com/vector-of-bool/pitchfork/develop/data/spec.bs
# =============================================================================

# =============================================================================
# build
# -----------------------------------------------------------------------------
# This directory is not required, but its name should be reserved.

# The build/ directory is special in that it must not be committed to a source
# control system. A user downloading the codebase should not see a build/
# directory present in the project root, but one may be created in the course of
# working with the software. The _build/ directory is also reserved.

# Note: Some build systems may commandeer the build/ directory for themselves.
# In this case, the directory _build/ should be used in place of build/.

# The build/ directory may be used for ephemeral build results. Other uses of
# the directory are not permitted.

# Creation of additional directories for build results in the root directory is
# not permitted.

# Note: Although multiple root directories are not allowed, the structure and
# layout of the build/ directory is not prescribed. Multiple subdirectories of
# build/ may be used to hold multiple build results of different configuration.
set(ProjectBuildFolder ${CMAKE_CURRENT_SOURCE_DIR}/build)
file(MAKE_DIRECTORY ${ProjectBuildFolder})

# =============================================================================
# § include
# -----------------------------------------------------------------------------
# The purpose of the include/ directory is to hold public API headers.

# The include/ directory should not be used if using § Merged File Placement.

# See § Library Source Layout.
set(ProjectIncludeFolder ${CMAKE_CURRENT_SOURCE_DIR}/include)
file(MAKE_DIRECTORY ${ProjectIncludeFolder})

# =============================================================================
# § src
# -----------------------------------------------------------------------------
# Note: The src/ and include/ directories are very closely related. Be sure to
# also read its section in addition to this one.

# The purpose and content of src/ depends on whether the project authors choose
# to follow § Merged File Placement or § Separate File Placement.

# See § Library Source Layout.
set(ProjectSourceFolder ${CMAKE_CURRENT_SOURCE_DIR}/src)
file(MAKE_DIRECTORY ${ProjectSourceFolder})

# =============================================================================
# § tests
# -----------------------------------------------------------------------------
# This directory is not required.

# The tests/ directory is reserved for source files related to (non-unit) tests
# for the project.

# The structure and layout of this directory is not prescribed by this document.

# A project which can be embedded in another project (such as via § external/),
# must disable its tests/ directory if it can detect that it is being built as
# an embedded sub-project.

# Project maintainers must provide a way for consumers to disable the
# compilation and running of tests, especially for the purpose of embedding.
set(ProjectTestsFolder ${CMAKE_CURRENT_SOURCE_DIR}/tests)
file(MAKE_DIRECTORY ${ProjectTestsFolder})

# =============================================================================
# § examples
# -----------------------------------------------------------------------------
# This directory is not required.

# The examples/ directory is reserved for source files related to example and
# sample usage of the project. The structure and layout of this directory is not
# prescribed by this document.

# Project maintainers must provide a way for consumers to disable the
# compilation of examples and samples.
set(ProjectExampleFolder ${CMAKE_CURRENT_SOURCE_DIR}/example)
file(MAKE_DIRECTORY ${ProjectExampleFolder})

# =============================================================================
# § external
# -----------------------------------------------------------------------------
# The external/ directory is reserved for embedding of external projects. Each
# embedded project should occupy a single subdirectory of external/.

# external/ should not contain files other than those required by tooling.

# This directory may be automatically populated, either partially or completely,
# by tools (eg. git submodules) as part of a build process. In this case,
# projects must declare the auto-populated subdirectories as ignored by relevant
# source control systems.

# Subdirectories of external/ should not be modified as part of regular project
# development. Subdirectories should remain as close to their upstream source as
# possible.
set(ProjectExternalFolder ${CMAKE_CURRENT_SOURCE_DIR}/external)
file(MAKE_DIRECTORY ${ProjectExternalFolder})

# =============================================================================
# § data
# -----------------------------------------------------------------------------
# This directory is not required.

# The data/ directory is designated for holding project files which should be
# included in revision control, but are not explicitly code. For example,
# graphics and localization files are not code in the same sense as the rest of
# the project, but are good candidates for inclusion in the data/ directory.

# The structure and layout of this directory is not prescribed by this document.
set(ProjectDataFolder ${CMAKE_CURRENT_SOURCE_DIR}/data)
file(MAKE_DIRECTORY ${ProjectDataFolder})

# =============================================================================
# § tools
# -----------------------------------------------------------------------------
# This directory is not required.

# The tools/ directory is designated for holding extra scripts and tools related
# to developing and contributing to the project. For example, turn-key build
# scripts, linting scripts, code-generation scripts, test scripts, or other
# tools that may be useful to a project develop.

# The contents of this directory should not be relevant to a project consumer.
set(ProjectToolsFolder ${CMAKE_CURRENT_SOURCE_DIR}/tools)
file(MAKE_DIRECTORY ${ProjectToolsFolder})

# cmake - C++ Build System Generator
set(ProjectCMakeFolder ${ProjectToolsFolder}/cmake)
file(MAKE_DIRECTORY ${ProjectCMakeFolder})

# conan - C++ Open Source Package Manager
set(ProjectConanFolder ${ProjectToolsFolder}/conan)
file(MAKE_DIRECTORY ${ProjectCMakeFolder})

# =============================================================================
# § docs
# -----------------------------------------------------------------------------
# This directory is not required.

# The docs/ directory is designated to contain project documentation. The
# documentation process, tools, and layout is not prescribed by this document.
set(ProjectDocumentationFolder ${CMAKE_CURRENT_SOURCE_DIR}/docs)
file(MAKE_DIRECTORY ${ProjectDocumentationFolder})

# =============================================================================
# § libs
# -----------------------------------------------------------------------------
# The libs/ directory must not be used unless the project wishes to subdivide
# itself into submodules. Its presence excludes the § src/ and § include/
# directories.

# See § 4 Submodules and § 4.3 libs/.
set(ProjectLibrariesFolder ${CMAKE_CURRENT_SOURCE_DIR}/libs)
file(MAKE_DIRECTORY ${ProjectLibrariesFolder})

# =============================================================================
# § extras
# -----------------------------------------------------------------------------
# This directory is not required.

# extras/ is a submodule root. See § 4 Submodules and § 4.4 extras/.
set(ProjectExtrasFolder ${CMAKE_CURRENT_SOURCE_DIR}/extras)
file(MAKE_DIRECTORY ${ProjectExtrasFolder})

# =============================================================================
# § Library Source Layout.
# -----------------------------------------------------------------------------
# This project supports two different methods of placing files in a single
# library: separate and merged. These two methods are mutually exclusive within
# a single library source tree.
#
# .............................................................................
# § Separate File Placement
#
# In separated placement, there are two source directories, include/ and src/.
# The include/ directory is designated to contain the public headers of the
# library, while the src/ directory is designated to contain the compilable
# source code and private headers.
#
# In separate placement, a single physical component is split between the two
# directories. The relative path to the parent directory of a compilable source
# file in the src/ directory must be equivalent to the relative path to the
# parent directory of the header in the include/ directory that corresponds to
# the compilable source file.
#
# Consumers of a library using separated header layout should be given the path
# to the § include/ directory as the sole include search directory for the
# library’s public interface. This prevents users from being able to #include
# paths which exist only in the src/ directory.
#
# The library itself should be compiled with both its § include/ and § src/
# directories as include search directories. This ensures that the library
# itself can access all files within both source directories.
#
# If not using merged tests, all tests should be placed within the tests/ top-
# level directory. There are no mandates on the layout within tests/.
#
# .............................................................................
# § Merged File Placement
#
# In merged header placement, there is a single source directory, § src/.
#
# Much like with separated placement, the relative path from the source
# directory to the parent of directory of the files of a physical component must
# be the same. This implies that the files of a physical component will always
# be sibling files in the same directory.
#
# Optional but recommended is to use merged test placement. In this method, a
# unit test should have exactly one compilable source file, and that filename
# stem should be the same as the filename stem of the physical component under
# test, with a .test appended to it. For example, a test for the physical
# component comprised of meow.hpp and meow.cpp will be named meow.test.cpp. This
# unit test source file should be placed in the same directory as a compilable
# source file of the physical component under test. Therefore, when the unit has
# a compilable source file, the unit test source file will appear as a sibling
# of the compilable source file.
# =============================================================================
option(
  MERGED_FILE_PLACEMENT
  "Provide an option for the file placement. ON means that source, header and test files will be placed together under src/. OFF means source files will be placed under src/, header files will be placed under include/ and test files under tests/."
  OFF)
