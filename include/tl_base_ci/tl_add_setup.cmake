# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/tl_common.cmake)
set(CURRENT_LIST_DIR ${CMAKE_CURRENT_LIST_DIR} CACHE INTERNAL "" FORCE)

# -----------------------------------------------------------------------------

function(tl_add_setup)

  # -----------------------------------------------------------------------------

  set(options "")
  set(one_value_args
    NAME
    BUILD_DIR
    BUILD_TYPE
    DESTINATION
    )
  set(multi_value_args
    CL_ARGS
    )

  cmake_parse_arguments(PARSED_ARGS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN} )

  # -----------------------------------------------------------------------------
  # Error Checking

  if (NOT PARSED_ARGS_NAME)
    TLOC_LOG(FATAL_ERROR "NAME must be provided")
  else()
    get_filename_component(${PARSED_ARGS_NAME} ${PARSED_ARGS_NAME} NAME_WE)
  endif()

  if(NOT PARSED_ARGS_BUILD_DIR)
    TLOC_LOG(FATAL_ERROR "BUILD_DIR must be provided")
  endif()

  if(NOT PARSED_ARGS_DESTINATION)
    set(PARSED_ARGS_DESTINATION ${CMAKE_SOURCE_DIR})
  endif()

  if (NOT PARSED_ARGS_BUILD_TYPE)
    set(PARSED_ARGS_BUILD_TYPE "Debug")
  endif()

  TLOC_SANITIZE_AND_CHECK_DIRECTORY(${PARSED_ARGS_DESTINATION} PARSED_ARGS_DESTINATION)

  if(PARSED_ARGS_UNPARSED_ARGS)
    TLOC_LOG(FATAL_ERROR "Unknown argument(s): ${PARSED_ARGS_UNPARSED_ARGS}")
  endif()

  # -----------------------------------------------------------------------------

  set(FILE_NAME ${PARSED_ARGS_NAME})
  set(FILE_DEST "${PARSED_ARGS_DESTINATION}/${FILE_NAME}")

  set(VAR_FILE_NAME ${PARSED_ARGS_NAME}_vars_user.cmake)
  set(VAR_FILE_DEST "${PARSED_ARGS_DESTINATION}/${VAR_FILE_NAME}")

  # -----------------------------------------------------------------------------
  # Get vars from user file, if it exists

  if (NOT EXISTS ${VAR_FILE_DEST})
    set(LOG_USER_VAR_FILE "Not found, writing ${VAR_FILE_NAME} to ${VAR_FILE_DEST}")
    configure_file(
      "${CURRENT_LIST_DIR}/configure_file/tl_setup_vars.cmake"
      ${VAR_FILE_DEST}
      @ONLY
    )
  else()
    set(LOG_USER_VAR_FILE "Found, will NOT create")
    include(${VAR_FILE_DEST})
  endif()

  # -----------------------------------------------------------------------------

  TLOC_LOG_LINE  (STATUS)
  TLOC_LOG       (STATUS "Writing ${FILE_NAME}.sh to ${PARSED_ARGS_DESTINATION} ...")
  TLOC_LOG_DETAIL(STATUS "Filename         : ${PARSED_ARGS_NAME}")
  TLOC_LOG_DETAIL(STATUS "Build directory  : ${PARSED_ARGS_BUILD_DIR}")
  TLOC_LOG_DETAIL(STATUS "Build Type       : ${PARSED_ARGS_BUILD_TYPE}")
  TLOC_LOG_DETAIL(STATUS "User Var File    : ${LOG_USER_VAR_FILE}")
  TLOC_LOG_DETAIL(STATUS "Command line args: ${PARSED_ARGS_CL_ARGS}")

  # -----------------------------------------------------------------------------
  file(WRITE "${CMAKE_BINARY_DIR}/${FILE_NAME}.sh"
"# -----------------------------------------------------------------------------
# auto-generated file, do not modify
# -----------------------------------------------------------------------------

rm -rf ${PARSED_ARGS_BUILD_DIR}
mkdir ${PARSED_ARGS_BUILD_DIR}

cd ${PARSED_ARGS_BUILD_DIR}
cmake ../ -DCMAKE_BUILD_TYPE=${PARSED_ARGS_BUILD_TYPE}"
)

  foreach(OPT ${PARSED_ARGS_CL_ARGS})
    file(APPEND "${CMAKE_BINARY_DIR}/${FILE_NAME}.sh" " ${OPT}")
  endforeach()

  file(APPEND "${CMAKE_BINARY_DIR}/${FILE_NAME}.sh"
"
make install"
  )

  file(COPY "${CMAKE_BINARY_DIR}/${FILE_NAME}.sh" DESTINATION ${PARSED_ARGS_DESTINATION}
  FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE)

  file(REMOVE "${CMAKE_BINARY_DIR}/${FILE_NAME}.sh")

  # -----------------------------------------------------------------------------

  TLOC_LOG_NEWLINE(STATUS)

  # -----------------------------------------------------------------------------

endfunction()
