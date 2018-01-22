# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/tl_common.cmake)

# -----------------------------------------------------------------------------
# Error Checking

if(NOT DEFINED EXT_LIB_NAME)
  TLOC_LOG(FATAL_ERROR "You forgot to set(EXT_LIB_NAME ...)")
endif()

if(NOT DEFINED ${EXT_LIB_NAME}_GIT_REPOSITORY)
  TLOC_LOG(FATAL_ERROR "You forgot to set(EXT_LIB_NAME ...)")
endif()

if(NOT DEFINED ${EXT_LIB_NAME}_GIT_TAG)
  set(${EXT_LIB_NAME}_GIT_TAG "master")
endif()

# -----------------------------------------------------------------------------

TLOC_LOG_DETAIL(STATUS "----------------------------------------------------------")
TLOC_LOG       (STATUS "Adding ${EXT_LIB_NAME} external library")
TLOC_LOG_DETAIL(STATUS "${EXT_LIB_NAME} Git Repository  : ${${EXT_LIB_NAME}_GIT_REPOSITORY}")
TLOC_LOG_DETAIL(STATUS "${EXT_LIB_NAME} Git Tag         : ${${EXT_LIB_NAME}_GIT_TAG}")
TLOC_LOG_DETAIL(STATUS "${EXT_LIB_NAME} CMAKE_ARGS      : ${${EXT_LIB_NAME}_CMAKE_ARGS")

# -----------------------------------------------------------------------------

include(ExternalProject)
find_package(${EXT_LIB_NAME} QUIET)

if(NOT ${EXT_LIB_NAME}_FOUND)
  TLOC_LOG(STATUS "${EXT_LIB_NAME} NOT FOUND. Source will be downloaded.")

  ExternalProject_Add(tl_base_ci_EXT
    GIT_REPOSITORY
      "${${EXT_LIB_NAME}_GIT_REPOSITORY}"
    GIT_TAG
      "${${EXT_LIB_NAME}_GIT_TAG}"

    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX=${TLOC_INSTALL_PREFIX}
      -DTLOC_DEP_SOURCE_DIR=${TLOC_DEP_SOURCE_DIR}
      ${${EXT_LIB_NAME}_CMAKE_ARGS}
    )
else()
  TLOC_LOG(STATUS "${EXT_LIB_NAME} FOUND: ${${EXT_LIB_NAME}_DIR}")

  ExternalProject_Add(tl_base_ci_EXT
    BINARY_DIR
      "${${EXT_LIB_NAME}_DIR}"
    SOURCE_DIR
      "${${EXT_LIB_NAME}_DIR}"
    BUILD_COMMAND
      "make"
    CONFIGURE_COMMAND ""
    DOWNLOAD_COMMAND ""
    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX=${TLOC_INSTALL_PREFIX}
      -DTLOC_DEP_SOURCE_DIR=${TLOC_DEP_SOURCE_DIR}
      ${${EXT_LIB_NAME}_CMAKE_ARGS}
  )
endif()

# -----------------------------------------------------------------------------

TLOC_LOG_DETAIL(STATUS "----------------------------------------------------------")

# -----------------------------------------------------------------------------
