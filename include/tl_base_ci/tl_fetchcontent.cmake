# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/tl_common.cmake)

# -----------------------------------------------------------------------------

# simpler version of CMake's ExternalProject_Add that does the job for us
function(tl_fetchcontent)

  # -----------------------------------------------------------------------------

  set(options
    FORCE_CLONE
    QUIET
    )
  set(one_value_args
    PROJ_NAME
    PACKAGE_NAME
    INSTALL_PREFIX
    GIT_REPOSITORY
    GIT_TAG
    CL_ARGS
    )
  set(multi_value_args "")

  cmake_parse_arguments(PARSED_ARGS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN} )

  # -----------------------------------------------------------------------------

  if(NOT PARSED_ARGS_FORCE_CLONE)
    set(PARSED_ARGS_FORCE_CLONE OFF)
  endif()

  if(NOT PARSED_ARGS_QUIET)
    set(PARSED_ARGS_QUIET ON)
  endif()

  if(NOT PARSED_ARGS_PROJ_NAME)
    TLOC_LOG(FATAL_ERROR "You must provide PROJ_NAME")
  endif()

  if(NOT PARSED_ARGS_INSTALL_PREFIX)
    set(PARSED_ARGS_INSTALL_PREFIX ${TLOC_INSTALL_PREFIX})
  endif()

  if(NOT PARSED_ARGS_PACKAGE_NAME)
    set(PARSED_ARGS_PACKAGE_NAME ${PARSED_ARGS_PROJ_NAME})
  endif()

  if(NOT PARSED_ARGS_GIT_REPOSITORY)
    TLOC_LOG(FATAL_ERROR "You must provide GIT_REPOSITORY")
  endif()

  # -----------------------------------------------------------------------------

  TLOC_LOG_LINE  (STATUS)
  TLOC_LOG       (STATUS "Adding ${PARSED_ARGS_PROJ_NAME} External Project")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_PROJ_NAME} Install Dir   : ${PARSED_ARGS_INSTALL_PREFIX}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_PROJ_NAME} Git Repository: ${PARSED_ARGS_GIT_REPOSITORY}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_PROJ_NAME} Git Tag       : ${PARSED_ARGS_GIT_TAG}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_PROJ_NAME} Test Command  : ${PARSED_ARGS_TEST_COMMAND}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_PROJ_NAME} CL Args       : ${PARSED_ARGS_CL_ARGS}")

  # -----------------------------------------------------------------------------

  if (NOT TLOC_ALWAYS_FETCHCONTENT)
    find_package(${PARSED_ARGS_PACKAGE_NAME} QUIET)
  endif()

  if(NOT ${PARSED_ARGS_PACKAGE_NAME}_FOUND OR TLOC_ALWAYS_FETCHCONTENT)

    include(FetchContent)
    set(FETCHCONTENT_QUIET ${PARSED_ARGS_QUIET})

    TLOC_LOG(STATUS "${PARSED_ARGS_PACKAGE_NAME} NOT FOUND. Downloading source...")

    FetchContent_Declare(${PARSED_ARGS_PROJ_NAME}
      GIT_REPOSITORY ${PARSED_ARGS_GIT_REPOSITORY}
      GIT_TAG ${PARSED_ARGS_GIT_TAG}

      CMAKE_ARGS ${PARSED_ARGS_CL_ARGS}
    )

    FetchContent_GetProperties(${PARSED_ARGS_PROJ_NAME})
    string(TOLOWER ${PARSED_ARGS_PROJ_NAME} PARSED_ARGS_PROJ_NAME_LOWER)

    if(NOT ${PARSED_ARGS_PROJ_NAME_LOWER}_POPULATED)
      FetchContent_Populate(${PARSED_ARGS_PROJ_NAME})
      add_subdirectory(
        ${${PARSED_ARGS_PROJ_NAME_LOWER}_SOURCE_DIR}
        ${${PARSED_ARGS_PROJ_NAME_LOWER}_BINARY_DIR}
      )

    endif()
  else()

    set(PACKAGE_DIR ${${PARSED_ARGS_PACKAGE_NAME}_DIR})
    TLOC_LOG(STATUS "${PARSED_ARGS_PACKAGE_NAME} FOUND: ${PACKAGE_DIR}")

  endif()

endfunction()
