# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/include_guard.cmake)
cmake_include_guard()

# -----------------------------------------------------------------------------
# Common options and variables

set(TLOC_DEP_SOURCE_DIR
  "${CMAKE_BINARY_DIR}" CACHE
  PATH "Dependencies will be cloned/downloaded here"
  )

set(TLOC_INSTALL_PREFIX
  "${CMAKE_INSTALL_PREFIX}" CACHE
  PATH "Projects (including dependencies) will be installed here"
  )

option(TLOC_DEP_DISABLE_TESTS
  "Disable tests for all dependencies" ON
  )

option(TLOC_ENABLE_DETAILED_LOGS
  "Enable detailed logging for all CMake operations" OFF
  )

set(TLOC_CXX_COMPILER_PATH
  "${CMAKE_CXX_COMPILER}" CACHE
  PATH "Path to the C++ compiler"
  )

# -----------------------------------------------------------------------------
# Logging

# MODE: same as CMake message(<mode>)
function(TLOC_LOG MODE MSG)
  message(${MODE} "${MSG}")
endfunction()

# Logs with TLOC_LOG_DETAIL will not appear by default
# MODE: same as CMake message(<mode>)
function(TLOC_LOG_DETAIL MODE MSG)
  if (TLOC_ENABLE_DETAILED_LOGS)
    message(${MODE} "${MSG}")
  endif()
endfunction()

# -----------------------------------------------------------------------------
