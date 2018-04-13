# -----------------------------------------------------------------------------

include_guard()

include(${CMAKE_CURRENT_LIST_DIR}/tl_logging.cmake)

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
