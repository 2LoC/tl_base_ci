# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/tl_common.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/tl_logging.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/tl_paths.cmake)

# -----------------------------------------------------------------------------
# Autogenerate all inclusive header

function(tl_autogen_single_include)

  # -----------------------------------------------------------------------------

  set(options "")
  set(one_value_args
    NAME
    DESTINATION
    )
  set(multi_value_args "")

  cmake_parse_arguments(PARSED_ARGS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN} )

  # -----------------------------------------------------------------------------
  # Error Checking

  if(NOT PARSED_ARGS_NAME)
    TLOC_LOG(FATAL_ERROR "You must provide a NAME")
  endif()

  if(NOT PARSED_ARGS_DESTINATION)
    TLOC_LOG(FATAL_ERROR "You must provide a DESTINATION folder")
  endif()

  TLOC_SANITIZE_AND_CHECK_DIRECTORY(${PARSED_ARGS_DESTINATION} PARSED_ARGS_DESTINATION)

  if(PARSED_ARGS_UNPARSED_ARGS)
    TLOC_LOG(FATAL_ERROR "Unknown argument(s): ${PARSED_ARGS_UNPARSED_ARGS}")
  endif()

  # -----------------------------------------------------------------------------

  set(FILE_NAME ${PARSED_ARGS_NAME})
  set(FILE_DEST ${PARSED_ARGS_DESTINATION})

  # -----------------------------------------------------------------------------

  set(FULL_PATH "${FILE_DEST}/${FILE_NAME}")
  file(REMOVE "${FULL_PATH}")
  file(GLOB_RECURSE ALL_HEADERS RELATIVE "${FILE_DEST}" *.h)

  # -----------------------------------------------------------------------------

  TLOC_LOG_LINE  (STATUS)
  TLOC_LOG       (STATUS "Creating all inclusive CPP header in ${FULL_PATH} ...")
  TLOC_LOG_DETAIL(STATUS "Headers found: ${ALL_HEADERS}")

  # -----------------------------------------------------------------------------

  file(WRITE "${FULL_PATH}"
"#pragma once

// Auto generated file, DO NOT overwrite
"
    )

  foreach(HEADER ${ALL_HEADERS})
    file(APPEND "${FULL_PATH}"
"#include \"${HEADER}\"\n"
      )
  endforeach(HEADER)

  # -----------------------------------------------------------------------------

  TLOC_LOG_LINE  (STATUS)

  # -----------------------------------------------------------------------------

endfunction(tl_autogen_single_include)
