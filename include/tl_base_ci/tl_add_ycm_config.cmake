# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/tl_common.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/tl_logging.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/tl_paths.cmake)

set(CURRENT_LIST_DIR ${CMAKE_CURRENT_LIST_DIR} CACHE INTERNAL "" FORCE)

# -----------------------------------------------------------------------------

function(tl_add_ycm_config)

  # -----------------------------------------------------------------------------

  set(options "")
  set(one_value_args
    DESTINATION
    )
  set(multi_value_args "")

  cmake_parse_arguments(PARSED_ARGS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN} )

  # -----------------------------------------------------------------------------
  # Error Checking

  if(NOT PARSED_ARGS_DESTINATION)
    set(PARSED_ARGS_DESTINATION ${PROJECT_SOURCE_DIR})
  endif()

  TLOC_SANITIZE_AND_CHECK_DIRECTORY(${PARSED_ARGS_DESTINATION} PARSED_ARGS_DESTINATION)

  if(PARSED_ARGS_UNPARSED_ARGS)
    TLOC_LOG(FATAL_ERROR "Unknown argument(s): ${PARSED_ARGS_UNPARSED_ARGS}")
  endif()

  # -----------------------------------------------------------------------------

  TLOC_LOG_LINE  (DEBUG)
  TLOC_LOG       (STATUS "Writing .ycm_extra_conf.py to ${PARSED_ARGS_DESTINATION} ...")

  # -----------------------------------------------------------------------------

  configure_file(
    "${CURRENT_LIST_DIR}/configure_file/tl_ycm_extra_conf.py.in"
    "${PARSED_ARGS_DESTINATION}/.ycm_extra_conf.py"
    @ONLY
    )

  # -----------------------------------------------------------------------------

  TLOC_LOG_NEWLINE(STATUS)

  # -----------------------------------------------------------------------------

endfunction(tl_add_ycm_config)
