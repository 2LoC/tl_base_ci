# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/tl_common.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/tl_logging.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/tl_string.cmake)

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
    TARGET_NAME
    NAMESPACE
    INSTALL_PREFIX
    GIT_REPOSITORY
    GIT_TAG
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

  # target name is usually the package name
  if(NOT PARSED_ARGS_TARGET_NAME)
    set(PARSED_ARGS_TARGET_NAME ${PARSED_ARGS_PACKAGE_NAME})
  endif()

  if(NOT PARSED_ARGS_GIT_REPOSITORY)
    TLOC_LOG(FATAL_ERROR "You must provide GIT_REPOSITORY")
  endif()

  # -----------------------------------------------------------------------------

  TLOC_LOG_LINE  (DEBUG)
  TLOC_LOG       (STATUS "Adding ${PARSED_ARGS_PROJ_NAME} External Project")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_PROJ_NAME} Install Dir   : ${PARSED_ARGS_INSTALL_PREFIX}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_PROJ_NAME} Git Repository: ${PARSED_ARGS_GIT_REPOSITORY}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_PROJ_NAME} Git Tag       : ${PARSED_ARGS_GIT_TAG}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_PROJ_NAME} Test Command  : ${PARSED_ARGS_TEST_COMMAND}")

  # -----------------------------------------------------------------------------

  if(TARGET ${PARSED_ARGS_PACKAGE_NAME})
    TLOC_LOG(FATAL_ERROR "Cannot FetchContent, ${PARSED_ARGS_PACKAGE_NAME} already exists...")
  endif()

  # -----------------------------------------------------------------------------
  set(NAMESPACE_AND_TARGET ${PARSED_ARGS_NAMESPACE}${PARSED_ARGS_TARGET_NAME})

  if (NOT TLOC_ALWAYS_FETCHCONTENT)
    find_package(${PARSED_ARGS_PACKAGE_NAME} QUIET)
  endif()

  # if package is found, but configuration is different, we need FetchContent # again
  if (${PARSED_ARGS_PACKAGE_NAME}_FOUND)
    TLOC_LOG_DETAIL(INFO "Package ${PARSED_ARGS_PACKAGE_NAME} found...")

    if (TARGET ${PARSED_ARGS_TARGET_NAME})
      get_target_property(PACKAGE_CONFIGS ${PARSED_ARGS_TARGET_NAME}
        IMPORTED_CONFIGURATIONS
        )
    elseif(TARGET ${NAMESPACE_AND_TARGET})
      get_target_property(PACKAGE_CONFIGS ${NAMESPACE_AND_TARGET}
        IMPORTED_CONFIGURATIONS
        )
    else()
      TLOC_LOG(FATAL_ERROR "Could not find target ${PARSED_ARGS_TARGET_NAME} for package ${PARSED_ARGS_PACKAGE_NAME}")
    endif()

    foreach(CONFIG ${PACKAGE_CONFIGS})
      TLOC_STREQUAL_LOWERCASE("${CONFIG}" "${CMAKE_BUILD_TYPE}" IS_EQUAL)
      TLOC_LOG(DEBUG "Is ${CONFIG} equal to ${CMAKE_BUILD_TYPE} for ${PARSED_ARGS_PACKAGE_NAME}: ${IS_EQUAL}")
      if (IS_EQUAL)
        set(${PARSED_ARGS_PACKAGE_NAME}_FOUND TRUE PARENT_SCOPE)
        break()
      endif()
    endforeach()

    if (NOT IS_EQUAL)
      TLOC_LOG_DETAIL(INFO "Could not find ${CMAKE_BUILD_TYPE} configuration for ${PARSED_ARGS_PACKAGE_NAME}")
      unset(${PARSED_ARGS_PACKAGE_NAME}_FOUND)
    endif()
  endif()

  if(NOT ${PARSED_ARGS_PACKAGE_NAME}_FOUND OR TLOC_ALWAYS_FETCHCONTENT)

    set(FETCHCONTENT_QUIET ${PARSED_ARGS_QUIET})
    include(FetchContent)

    TLOC_LOG(STATUS "${PARSED_ARGS_PACKAGE_NAME} NOT FOUND. Downloading source...")

    FetchContent_Declare(${PARSED_ARGS_PROJ_NAME}
      GIT_REPOSITORY ${PARSED_ARGS_GIT_REPOSITORY}
      GIT_TAG ${PARSED_ARGS_GIT_TAG}
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
