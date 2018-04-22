# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/tl_common.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/tl_logging.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/tl_paths.cmake)

# -----------------------------------------------------------------------------

function(tl_add_executable)

  # -----------------------------------------------------------------------------

  set(options "")
  set(one_value_args
    EXE_NAME

    CXX_STANDARD
    CXX_STANDARD_REQUIRED
    )
  set(multi_value_args

    HEADER_FILES
    SOURCE_FILES

    INCLUDE_DIRS
    LINK_LIBS

    FIND_PACKAGES

    BUILD_INTERFACE
    INSTALL_INTERFACE
    )

  cmake_parse_arguments(PARSED_ARGS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN} )

  # -----------------------------------------------------------------------------
  # Error Checking

  if(NOT PARSED_ARGS_EXE_NAME)
    TLOC_LOG(FATAL_ERROR "You must provide EXE_NAME")
  endif()

  if(NOT PARSED_ARGS_SOURCE_FILES)
    TLOC_LOG(FATAL_ERROR "You must provide SOURCE_FILES")
  endif()

  if(PARSED_ARGS_UNPARSED_ARGS)
    TLOC_LOG(FATAL_ERROR "Unknown argument(s): ${PARSED_ARGS_UNPARSED_ARGS}")
  endif()

  # -----------------------------------------------------------------------------

  add_executable(${PARSED_ARGS_EXE_NAME}
    ${PARSED_ARGS_HEADER_FILES}
    ${PARSED_ARGS_SOURCE_FILES}
    )

  # -----------------------------------------------------------------------------

  if(NOT PARSED_ARGS_BUILD_INTERFACE)
    set(PARSED_ARGS_BUILD_INTERFACE ${${PARSED_ARGS_EXE_NAME}_SOURCE_DIR})
  endif()

  if(NOT PARSED_ARGS_INSTALL_INTERFACE)
    set(PARSED_ARGS_INSTALL_INTERFACE "include/")
  endif()

  # -----------------------------------------------------------------------------

  TLOC_LOG_LINE  (DEBUG)
  TLOC_LOG       (STATUS "Adding ${PARSED_ARGS_EXE_NAME} executable")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_EXE_NAME} Headers          : ${PARSED_ARGS_HEADER_FILES}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_EXE_NAME} Source Files     : ${PARSED_ARGS_SOURCE_FILES}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_EXE_NAME} Link libraries   : ${PARSED_ARGS_LINK_LIBS}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_EXE_NAME} Find Packages    : ${PARSED_ARGS_FIND_PACKAGES}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_EXE_NAME} Include Dirs     : ${PARSED_ARGS_INCLUDE_DIRS}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_EXE_NAME} Build Interface  : ${PARSED_ARGS_BUILD_INTERFACE}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_EXE_NAME} Install Interface: ${PARSED_ARGS_INSTALL_INTERFACE}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_EXE_NAME} CXX Standard     : ${PARSED_ARGS_CXX_STANDARD}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_EXE_NAME} CXX Standard Req : ${PARSED_ARGS_CXX_STANDARD_REQUIRED}")

  # -----------------------------------------------------------------------------

  foreach(PACKAGE ${PARSED_ARGS_FIND_PACKAGES})
    find_package(${PACKAGE} QUIET)
  endforeach()

  # -----------------------------------------------------------------------------

  target_include_directories(${PARSED_ARGS_EXE_NAME}
    PRIVATE
      $<BUILD_INTERFACE:${PARSED_ARGS_BUILD_INTERFACE}>
      $<INSTALL_INTERFACE:${PARSED_ARGS_INSTALL_INTERFACE}>
      ${PARSED_ARGS_INCLUDE_DIRS}
    )

  target_link_libraries(${PARSED_ARGS_EXE_NAME}
    PRIVATE
      ${PARSED_ARGS_LINK_LIBS}
    )

  if (PARSED_ARGS_CXX_STANDARD)
    set_target_properties(${PARSED_ARGS_EXE_NAME}
      PROPERTIES
      CXX_STANDARD ${PARSED_ARGS_CXX_STANDARD}
    )
  endif()

  if (PARSED_ARGS_CXX_STANDARD_REQUIRED)
    set_target_properties(${PARSED_ARGS_EXE_NAME}
      PROPERTIES
      CXX_STANDARD_REQUIRED ${PARSED_ARGS_CXX_STANDARD_REQUIRED}
    )
  endif()

  install(TARGETS ${PARSED_ARGS_EXE_NAME}
    EXPORT ${PARSED_ARGS_EXE_NAME}Config
    RUNTIME DESTINATION "bin/${PARSED_ARGS_EXE_NAME}/"
    )

  install(EXPORT ${PARSED_ARGS_EXE_NAME}Config
    DESTINATION "cmake/"
    )

  # -----------------------------------------------------------------------------

  TLOC_LOG_NEWLINE(STATUS)

  # -----------------------------------------------------------------------------

endfunction(tl_add_executable)

# All tl_ libraries follow the following directory structure:
#
# Root
# |-include/${LIB_NAME}/public_headers_go_here.h
#
# FAQ
# (1) Why are the public headers under ${LIB_NAME} and not "include/"?

# Ans: If the public headers are under "include/" directly, then the end
# user will write `#include <LibHeader.h>` instead of
# `#include <LibName/LibHeader.h>`. This will of course reduce overall
# collisions in case LibA and LibB, both have the same header
#
# (2) What variables do I need to set?
#
# Ans:
# 1 - LIB_NAME
# 2 - ${LIB_NAME}_PUBLIC_HEADERS
# 3 - ${LIB_NAME}_PRIVATE_HEADERS # optional
# 4 - ${LIB_NAME}_SOURCE_FILES # optional
# 4 - ${LIB_NAMESPACE}
#
# (3) Do I have to use this file to add libraries?
#
# Ans: If you are contributing to the tl_ libraries, yes. This is to
#      to keep things consistent for everybody.

#      CMake has undergone some major changes to make it more 'modern' and
#      we are still figuring out the best ways to do something. It is easier
#      to adjust a common file.
#
# (4) What if there is something missing that I want to add?
#
# Ans: Feel free to add the feature to this file. Assuming it doesn't
#      affect the builds and they all pass, you're good to go.
