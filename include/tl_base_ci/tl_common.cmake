# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/tl_include_guard.cmake)
cmake_include_guard()

# -----------------------------------------------------------------------------
# common options and variables

set(TLOC_DEP_SOURCE_DIR
  "${CMAKE_BINARY_DIR}" CACHE
  PATH "Dependencies will be cloned/downloaded here"
  )
set(CMAKE_BINARY_DIR ${TLOC_DEP_SOURCE_DIR})

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

option(TLOC_GENERATE_COMPILE_COMMANDS
  "Used for autocomplete features, mainly on Linux" ON
  )

option(TLOC_IGNORE_FATAL_ERROR
  "Ignore FATAL_ERRORs (only in TLOG_LOG)" OFF
  )

set(TLOC_CXX_COMPILER_PATH
  "${CMAKE_CXX_COMPILER}" CACHE
  PATH "Path to the C++ compiler"
  )

# -----------------------------------------------------------------------------
# debug builds

set(CMAKE_DEBUG_POSTFIX _d)

# -----------------------------------------------------------------------------
# C++11

set(CMAKE_CXX_STANDARD 11)

# -----------------------------------------------------------------------------
# colors

if(NOT WIN32)
  string(ASCII 27 Esc)
  set(ColourReset "${Esc}[m")
  set(ColourBold  "${Esc}[1m")
  set(Red         "${Esc}[31m")
  set(Green       "${Esc}[32m")
  set(Yellow      "${Esc}[33m")
  set(Blue        "${Esc}[34m")
  set(Magenta     "${Esc}[35m")
  set(Cyan        "${Esc}[36m")
  set(White       "${Esc}[37m")
  set(BoldRed     "${Esc}[1;31m")
  set(BoldGreen   "${Esc}[1;32m")
  set(BoldYellow  "${Esc}[1;33m")
  set(BoldBlue    "${Esc}[1;34m")
  set(BoldMagenta "${Esc}[1;35m")
  set(BoldCyan    "${Esc}[1;36m")
  set(BoldWhite   "${Esc}[1;37m")
endif()

# -----------------------------------------------------------------------------
# logging

# MODE: same as CMake message(<mode>)
function(TLOC_LOG MODE MSG)
  if(${MODE} STREQUAL "STATUS")
    message(${MODE} "${BoldBlue}${MSG}${ColourReset}")
  elseif(${MODE} STREQUAL "WARNING")
    message(${MODE} "${BoldYellow}${MSG}${ColourReset}")
  elseif(${MODE} STREQUAL "FATAL_ERROR" OR ${MODE} STREQUAL "SEND_ERROR")
    if (TLOC_IGNORE_FATAL_ERROR)
      set(MODE "WARNING")
    endif()
    message(${MODE} "${BoldRed}${MSG}${ColourReset}")
  elseif(${MODE} STREQUAL "DEPRECATION")
    message(${MODE} "${Yellow}${MSG}${ColourReset}")
  else()
    message(${MODE} ${MSG})
  endif()
endfunction()

# Logs with TLOC_LOG_DETAIL will not appear by default
# MODE: same as CMake message(<mode>)
function(TLOC_LOG_DETAIL MODE MSG)
  if (TLOC_DETAILED_LOGS)
    TLOC_LOG(${MODE} "${MSG}")
  endif()
endfunction()

function(TLOC_LOG_LINE MODE)
  TLOC_LOG_DETAIL(${MODE} "----------------------------------------------------------")
endfunction()

function(TLOC_LOG_NEWLINE MODE)
  TLOC_LOG_DETAIL(${MODE} " ")
endfunction()

function(TLOC_LOG_DETAIL_VAR MODE _VAR)
  TLOC_LOG_DETAIL(${MODE} "${_VAR}: ${${_VAR}}")
endfunction()

function(TLOC_LOG_VAR MODE _VAR)
  TLOC_LOG(${MODE} "${_VAR}: ${${_VAR}}")
endfunction()

# -----------------------------------------------------------------------------
# compile_commands

if(TLOC_GENERATE_COMPILE_COMMANDS)
  set(CMAKE_EXPORT_COMPILE_COMMANDS "ON")
endif()

# -----------------------------------------------------------------------------
# install

set(CMAKE_INSTALL_PREFIX ${TLOC_INSTALL_PREFIX})

# -----------------------------------------------------------------------------
# emulating maps

MACRO(INSERT_INTO_MAP _NAME _KEY _VALUE)
  SET("${_NAME}_${_KEY}" "${_VALUE}")
ENDMACRO(INSERT_INTO_MAP)

# -----------------------------------------------------------------------------
# logging

TLOC_LOG_LINE(STATUS)
TLOC_LOG_DETAIL(STATUS "tl_common.cmake variables...")
TLOC_LOG_DETAIL_VAR(STATUS TLOC_INSTALL_PREFIX)
TLOC_LOG_DETAIL_VAR(STATUS TLOC_GENERATE_COMPILE_COMMANDS)
TLOC_LOG_DETAIL_VAR(STATUS TLOC_DETAILED_LOGS)
TLOC_LOG_DETAIL_VAR(STATUS TLOC_CXX_COMPILER_PATH)
TLOC_LOG_DETAIL_VAR(STATUS TLOC_DEP_SOURCE_DIR)
TLOC_LOG_DETAIL_VAR(STATUS TLOC_DEP_DISABLE_TESTS)
TLOC_LOG_NEWLINE(STATUS)

# -----------------------------------------------------------------------------
# error checking

function(TLOC_SANITIZE_AND_CHECK_DIRECTORY PATH_IN PATH_OUT)
  get_filename_component(PATH_IN ${PATH_IN} ABSOLUTE)

  if(NOT IS_DIRECTORY ${PATH_IN})
    TLOC_LOG(FATAL_ERROR "Path is not a directory: ${PATH_IN}")
  endif()

  if(NOT EXISTS ${PATH_IN})
    TLOC_LOG(FATAL_ERROR "Path does not exist: ${PATH_IN}")
  endif()

  set(${PATH_OUT} ${PATH_IN} PARENT_SCOPE)
endfunction()

# -----------------------------------------------------------------------------
# prevent in source compilation

if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
  TLOC_LOG(FATAL_ERROR "Please build in a directory that is not the source directory")
endif()

# -----------------------------------------------------------------------------
# include helper

function(TLOC_INCLUDE FILE PATHS)
  foreach(PATH ${PATHS})
    set(FULL_PATH ${PATH}${FILE})
    if (EXISTS ${FULL_PATH})
      TLOC_LOG_DETAIL(STATUS "Including file: ${FULL_PATH}")
      include(${FULL_PATH})
      return()
    endif()
  endforeach()
  message(FATAL_ERROR "Could not find file ${FILE} to include in paths ${PATHS}")
endfunction()
