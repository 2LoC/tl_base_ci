# -----------------------------------------------------------------------------

include_guard()

include(${CMAKE_CURRENT_LIST_DIR}/tl_logging.cmake)

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
  TLOC_LOG(FATAL_ERROR "Could not find file ${FILE} to include in paths ${PATHS}")
endfunction()
