# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/tl_common.cmake)

# -----------------------------------------------------------------------------

function(tl_add_library)

  # -----------------------------------------------------------------------------

  set(options "")
  set(one_value_args
    LIB_NAME
    )
  set(multi_value_args
    PUBLIC_HEADER_FILES
    PRIVATE_HEADER_FILES
    SOURCE_FILES
    PUBLIC_INCLUDE_DIRS
    PRIVATE_INCLUDE_DIRS
    PUBLIC_LINK_LIBS
    PRIVATE_LINK_LIBS
    PUBLIC_FIND_PACKAGES
    PRIVATE_FIND_PACKAGES
    BUILD_INTERFACE
    INSTALL_INTERFACE
    )

  cmake_parse_arguments(PARSED_ARGS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN} )

  # -----------------------------------------------------------------------------

  if(NOT PARSED_ARGS_LIB_NAME)
    TLOC_LOG(FATAL_ERROR "You must provide LIB_NAME")
  endif()

  if(NOT PARSED_ARGS_PUBLIC_HEADER_FILES)
    TLOC_LOG(FATAL_ERROR "You must provide PUBLIC_HEADER_FILES")
  endif()

  if(NOT PARSED_ARGS_SOURCE_FILES)
    TLOC_LOG(FATAL_ERROR "You must provide SOURCE_FILES (or use tl_add_interface)")
  endif()

  if(PARSED_ARGS_UNPARSED_ARGS)
    TLOC_LOG(FATAL_ERROR "Unknown argument(s): ${PARSED_ARGS_UNPARSED_ARGS}")
  endif()

  # -----------------------------------------------------------------------------

  add_library(${PARSED_ARGS_LIB_NAME}
    ${PARSED_ARGS_PUBLIC_HEADER_FILES}
    ${PARSED_ARGS_PRIVATE_HEADER_FILES}
    ${PARSED_ARGS_SOURCE_FILES}
    )

  # -----------------------------------------------------------------------------

  if(NOT PARSED_ARGS_BUILD_INTERFACE)
    set(PARSED_ARGS_BUILD_INTERFACE ${${PARSED_ARGS_LIB_NAME}_SOURCE_DIR}/include/)
  endif()

  if(NOT PARSED_ARGS_INSTALL_INTERFACE)
    set(PARSED_ARGS_INSTALL_INTERFACE "install/")
  endif()

  # -----------------------------------------------------------------------------

  TLOC_LOG_LINE  (STATUS)
  TLOC_LOG       (STATUS "Adding ${PARSED_ARGS_LIB_NAME} library")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_LIB_NAME} Public Headers   : ${PARSED_ARGS_PUBLIC_HEADER_FILES}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_LIB_NAME} Private Headers  : ${PARSED_ARGS_PRIVATE_HEADER_FILES}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_LIB_NAME} Source Files     : ${PARSED_ARGS_SOURCE_FILES}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_LIB_NAME} Public Libs      : ${PARSED_ARGS_PUBLIC_LINK_LIBS}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_LIB_NAME} Private Libs     : ${PARSED_ARGS_PRIVATE_LINK_LIBS}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_LIB_NAME} Public Packages  : ${PARSED_ARGS_PUBLIC_FIND_PACKAGES}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_LIB_NAME} Private Packages : ${PARSED_ARGS_PRIVATE_FIND_PACKAGES}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_LIB_NAME} Public Incl Dirs : ${PARSED_ARGS_PUBLIC_INCLUDE_DIRS}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_LIB_NAME} Private Incl Dirs: ${PARSED_ARGS_PRIVATE_INCLUDE_DIRS}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_LIB_NAME} Build Interface  : ${PARSED_ARGS_BUILD_INTERFACE}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_LIB_NAME} Install Interface: ${PARSED_ARGS_INSTALL_INTERFACE}")

  # -----------------------------------------------------------------------------

  foreach(PACKAGE ${PARSED_ARGS_PUBLIC_FIND_PACKAGES})
    find_package(${PACKAGE} QUIET)
    list(APPEND PARSED_ARGS_PUBLIC_LINK_LIBS ${PACKAGE})
  endforeach()

  foreach(PACKAGE ${PARSED_ARGS_PRIVATE_FIND_PACKAGES})
    find_package(${PACKAGE} QUIET)
    list(APPEND PARSED_ARGS_PRIVATE_LINK_LIBS ${PACKAGE})
  endforeach()

  # -----------------------------------------------------------------------------

  set_target_properties(${PARSED_ARGS_LIB_NAME}
    PROPERTIES PUBLIC_HEADER "${PARSED_ARGS_PUBLIC_HEADER_FILES}"
    )

  target_include_directories(${PARSED_ARGS_LIB_NAME}
    PUBLIC
      $<BUILD_INTERFACE:${PARSED_ARGS_BUILD_INTERFACE}>
      $<INSTALL_INTERFACE:${PARSED_ARGS_INSTALL_INTERFACE}>
      ${PARSED_ARGS_PUBLIC_INCLUDE_DIRS}
    PRIVATE
      ${PARSED_ARGS_PRIVATE_INCLUDE_DIRS}
    )

  target_link_libraries(${PARSED_ARGS_LIB_NAME}
    PUBLIC
      ${PARSED_ARGS_PUBLIC_LINK_LIBS}
    PRIVATE
      ${PARSED_ARGS_PRIVATE_LINK_LIBS}
    )

  install(TARGETS ${PARSED_ARGS_LIB_NAME}
    EXPORT ${PARSED_ARGS_LIB_NAME}Config
    PUBLIC_HEADER DESTINATION "include/${PARSED_ARGS_LIB_NAME}"
    RUNTIME       DESTINATION "bin/${PARSED_ARGS_LIB_NAME}/"
    LIBRARY       DESTINATION "lib/${PARSED_ARGS_LIB_NAME}/"
    ARCHIVE       DESTINATION "lib/${PARSED_ARGS_LIB_NAME}/static/"

    PERMISSIONS OWNER_READ
    )

  install(EXPORT ${PARSED_ARGS_LIB_NAME}Config
    DESTINATION "cmake/"

    PERMISSIONS OWNER_READ
    )

  export(TARGETS ${PARSED_ARGS_LIB_NAME} FILE ${PARSED_ARGS_LIB_NAME}Config.cmake)
  export(PACKAGE ${PARSED_ARGS_LIB_NAME})

  # -----------------------------------------------------------------------------

  TLOC_LOG_NEWLINE(STATUS)

  # -----------------------------------------------------------------------------


endfunction(tl_add_library)

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
