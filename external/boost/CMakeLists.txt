# ./external/boost/CMakeLists.txt

set(BOOST_VERSION 1.74.0)

# Settings for finding correct Boost libraries.
set(Boost_USE_STATIC_LIBS FALSE)
set(Boost_USE_MULTITHREADED TRUE)
set(Boost_USE_STATIC_RUNTIME FALSE)
set(Boost_COMPILER "-gcc8")
# set(Boost_ADDITIONAL_VERSIONS "${BOOST_VERSION}")

# Search for Boost libraries.
find_package(
  Boost
  ${BOOST_VERSION}
  EXACT #
  CONFIG # MODULE
  REQUIRED #
  # Omitting any component only looks for header-only Boost libraries COMPONENTS
  ALL # headers # program_options graph
  # with Boost 1.73.0 => ALL is available (Disclaimer: all installed)
)

# Make found targets globally available.
if(Boost_FOUND)
  set_target_properties(
    ${Boost_ALL_TARGETS} # Boost::headers # Boost::boost Boost::program_options
                         # # Boost::graph #
    PROPERTIES IMPORTED_GLOBAL TRUE)
else()
  message(WARNING "[DEBUG] - Boost not found")
endif()
