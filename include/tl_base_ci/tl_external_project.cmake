# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/tl_common.cmake)

# -----------------------------------------------------------------------------

# simpler version of CMake's ExternalProject_Add that does the job for us
function(tl_external_project_add)

  # -----------------------------------------------------------------------------

  set(options
    FORCE_CLONE
    )
  set(one_value_args
    PROJ_NAME
    PACKAGE_NAME
    INSTALL_PREFIX
    GIT_REPOSITORY
    GIT_TAG
    TEST_COMMAND
    CL_ARGS
    )
  set(multi_value_args "")

  cmake_parse_arguments(PARSED_ARGS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN} )

  # -----------------------------------------------------------------------------

  if(NOT PARSED_ARGS_FORCE_CLONE)
    set(PARSED_ARGS_FORCE_CLONE OFF)
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

  find_package(${PARSED_ARGS_PACKAGE_NAME} QUIET)
  if(${PARSED_ARGS_PACKAGE_NAME}_FOUND)
    set(PACKAGE_DIR ${${PARSED_ARGS_PACKAGE_NAME}_DIR})
    TLOC_LOG(STATUS "${PARSED_ARGS_PACKAGE_NAME} FOUND: ${PACKAGE_DIR}")

    ExternalProject_Add(${PARSED_ARGS_NAME}
      BINARY_DIR ${PACKAGE_DIR}
      SOURCE_DIR ${PACKAGE_DIR}

      CMAKE_ARGS ${PARSED_ARGS_CL_ARGS}
    )
  else()
    include(ExternalProject)

    TLOC_LOG(STATUS "${PARSED_ARGS_PACKAGE_NAME} NOT FOUND. Downloading source...")

    ExternalProject_Add(${PARSED_ARGS_PROJ_NAME}
      GIT_REPOSITORY ${PARSED_ARGS_GIT_REPOSITORY}

      GIT_TAG ${PARSED_ARGS_GIT_TAG}

      SOURCE_DIR "${TLOC_DEP_SOURCE_DIR}/${PARSED_ARGS_PROJ_NAME}"

      CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=${PARSED_ARGS_INSTALL_PREFIX}
        -DCMAKE_DEBUG_POSTFIX=_d
        ${PARSED_ARGS_CL_ARGS}

      TEST_COMMAND ${PARSED_ARGS_TEST_COMMAND}
      )
  endif()

endfunction()
