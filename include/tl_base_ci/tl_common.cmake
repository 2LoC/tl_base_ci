# -----------------------------------------------------------------------------

include_guard()

include(${CMAKE_CURRENT_LIST_DIR}/tl_logging.cmake)

# -----------------------------------------------------------------------------
# common options and variables

set(TLOC_DEP_SOURCE_DIR
  "${CMAKE_BINARY_DIR}" CACHE
  PATH "Dependencies will be cloned/downloaded here"
  )

set(TLOC_INSTALL_PREFIX
  "${CMAKE_INSTALL_PREFIX}" CACHE
  PATH "Projects (including dependencies) will be installed here"
  )
set(CMAKE_INSTALL_PREFIX ${TLOC_INSTALL_PREFIX})

option(TLOC_DISABLE_TESTS
  "Disable tests for all projects (excluding dependencies)" OFF
  )

option(TLOC_DEP_DISABLE_TESTS
  "Disable tests for all dependencies" ON
  )

option(TLOC_DETAILED_LOGS
  "Enable detailed logging for all CMake operations" OFF
  )

option(TLOC_EXPORT_COMPILE_COMMANDS
  "Used for autocomplete features, mainly on Linux" ON
  )

option(TLOC_IGNORE_FATAL_ERROR
  "Ignore FATAL_ERRORs (only in TLOG_LOG)" OFF
  )

option(TLOC_ALWAYS_FETCHCONTENT
  "find_package is not used regardless of whether the project exists already" OFF
  )

set(TLOC_CXX_COMPILER_PATH
  "${CMAKE_CXX_COMPILER}" CACHE
  PATH "Path to the C++ compiler"
  )

# -----------------------------------------------------------------------------
# debug builds

set(CMAKE_DEBUG_POSTFIX _d)

# -----------------------------------------------------------------------------
# force one configuration builds
# notes: this is to ensure that we can query which configuration we are building
# and then match the FetchContent packages properly

if(NOT CMAKE_BUILD_TYPE AND NOT TLOC_BUILD_TYPE)
  TLOC_LOG(FATAL_ERROR "CMAKE_BUILD_TYPE must be specified (Debug, Release, RelWithDebInfo, MinSizeRel")
else()
  if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE ${TLOC_BUILD_TYPE} CACHE STRING INTERNAL)
  else()
    set(TLOC_BUILD_TYPE ${CMAKE_BUILD_TYPE} CACHE STRING INTERNAL)
  endif()
endif()

# only support one build configuration per build-tree
set(CMAKE_CONFIGURATION_TYPES ${CMAKE_BUILD_TYPE} FORCE)

# -----------------------------------------------------------------------------
# logging

function(TLOC_LOG_COMMON_VARIABLES)
  TLOC_LOG_LINE      (DEBUG)
  TLOC_LOG_DETAIL    (STATUS "tl_common.cmake variables...")
  TLOC_LOG_DETAIL_VAR(STATUS TLOC_INSTALL_PREFIX)
  TLOC_LOG_DETAIL_VAR(STATUS TLOC_DISABLE_TESTS)
  TLOC_LOG_DETAIL_VAR(STATUS TLOC_DEP_DISABLE_TESTS)
  TLOC_LOG_DETAIL_VAR(STATUS TLOC_EXPORT_COMPILE_COMMANDS)
  TLOC_LOG_DETAIL_VAR(STATUS TLOC_DETAILED_LOGS)
  TLOC_LOG_DETAIL_VAR(STATUS TLOC_CXX_COMPILER_PATH)
  TLOC_LOG_DETAIL_VAR(STATUS TLOC_DEP_SOURCE_DIR)
  TLOC_LOG_DETAIL_VAR(STATUS TLOC_DEP_DISABLE_TESTS)
  TLOC_LOG_DETAIL_VAR(STATUS TLOC_BUILD_TYPE)
  TLOC_LOG_NEWLINE(STATUS)
endfunction()

# -----------------------------------------------------------------------------
# prevent in source compilation

if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
  TLOC_LOG(FATAL_ERROR "Please build in a directory that is not the source directory")
endif()
