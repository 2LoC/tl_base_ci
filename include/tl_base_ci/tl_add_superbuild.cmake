# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/tl_common.cmake)
set(CURRENT_LIST_DIR ${CMAKE_CURRENT_LIST_DIR} CACHE INTERNAL "" FORCE)

# -----------------------------------------------------------------------------

function(tl_add_superbuild)

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
    TLOC_LOG(FATAL_ERROR "Destination is required for superbuild.")
  endif()

  TLOC_SANITIZE_AND_CHECK_DIRECTORY(${PARSED_ARGS_DESTINATION} PARSED_ARGS_DESTINATION)

  if(PARSED_ARGS_UNPARSED_ARGS)
    TLOC_LOG(FATAL_ERROR "Unknown argument(s): ${PARSED_ARGS_UNPARSED_ARGS}")
  endif()

  # -----------------------------------------------------------------------------

  set(FILE_NAME "CMakeLists.txt")
  set(FILE_DEST "${PARSED_ARGS_DESTINATION}/${FILE_NAME}")

  # -----------------------------------------------------------------------------

  TLOC_LOG_LINE  (STATUS)
  TLOC_LOG       (STATUS "Writing ${FILE_NAME} Superbuild to ${PARSED_ARGS_DESTINATION} ...")

  # -----------------------------------------------------------------------------

  configure_file(
    "${CURRENT_LIST_DIR}/configure_file/tl_superbuild_cmakelists.cmake.in"
    ${FILE_DEST}
    @ONLY
    )

  # -----------------------------------------------------------------------------

  TLOC_LOG_NEWLINE(STATUS)

  # -----------------------------------------------------------------------------

endfunction(tl_add_superbuild)
