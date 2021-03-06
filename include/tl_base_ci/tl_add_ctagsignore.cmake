# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/tl_common.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/tl_logging.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/tl_paths.cmake)

# -----------------------------------------------------------------------------

function(tl_add_ctagsignore)

  # -----------------------------------------------------------------------------

  set(options
    NO_DEFAULTS
    )
  set(one_value_args
    NAME
    DESTINATION
    )
  set(multi_value_args
    IGNORE_LIST
    )

  cmake_parse_arguments(PARSED_ARGS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN} )

  # -----------------------------------------------------------------------------
  # Error Checking

  if(NOT PARSED_ARGS_NAME)
    set(PARSED_ARGS_NAME ".ctagsignore")
  endif()

  if(NOT PARSED_ARGS_DESTINATION)
    set(PARSED_ARGS_DESTINATION ${PROJECT_SOURCE_DIR})
  endif()

  TLOC_SANITIZE_AND_CHECK_DIRECTORY(${PARSED_ARGS_DESTINATION} PARSED_ARGS_DESTINATION)

  if(PARSED_ARGS_UNPARSED_ARGS)
    TLOC_LOG(FATAL_ERROR "Unknown argument(s): ${PARSED_ARGS_UNPARSED_ARGS}")
  endif()

  # -----------------------------------------------------------------------------

  set(FILE_NAME ${PARSED_ARGS_NAME})
  set(FILE_DEST "${PARSED_ARGS_DESTINATION}/${FILE_NAME}")

  # -----------------------------------------------------------------------------

  TLOC_LOG_LINE  (STATUS)
  TLOC_LOG       (STATUS "Writing ${FILE_NAME} to ${PARSED_ARGS_DESTINATION} ...")
  TLOC_LOG_DETAIL(STATUS "no defaults: ${PARSED_ARGS_NO_DEFAULTS}")
  TLOC_LOG_DETAIL(STATUS "ignore list: ${PARSED_ARGS_IGNORE_LIST}")

  # -----------------------------------------------------------------------------

  if(NOT PARSED_ARGS_NO_DEFAULTS)
    set(DEFAULT_IGNORE_LIST
      "\
build*
install*
"
  )
  endif()

  # -----------------------------------------------------------------------------

  file(WRITE ${FILE_DEST}
"\
# ----------------------------------
# auto-generated file, do not modify
# ----------------------------------

# ----------------------------------
# DEFAULT_IGNORE_LIST
# ----------------------------------

${DEFAULT_IGNORE_LIST}

# ----------------------------------
# USER DEFINED IGNORE_LIST
# ----------------------------------

${PARSED_ARGS_IGNORE_LIST}
"
  )

  # -----------------------------------------------------------------------------

  TLOC_LOG_NEWLINE(STATUS)

  # -----------------------------------------------------------------------------

endfunction()
