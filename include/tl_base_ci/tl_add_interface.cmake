# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/tl_common.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/tl_logging.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/tl_paths.cmake)

# -----------------------------------------------------------------------------

function(tl_add_interface)

  # -----------------------------------------------------------------------------

  set(options "")
  set(one_value_args
    LIB_NAME

    CXX_STANDARD
    CXX_STANDARD_REQUIRED
    )
  set(multi_value_args
    HEADER_FILES
    INCLUDE_DIRS

    LINK_LIBS
    FIND_PACKAGES

    BUILD_INTERFACE
    INSTALL_INTERFACE
    )

  cmake_parse_arguments(PARSED_ARGS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN} )

  # -----------------------------------------------------------------------------

  # -----------------------------------------------------------------------------

  if(NOT PARSED_ARGS_LIB_NAME)
    TLOC_LOG(FATAL_ERROR "You must provide LIB_NAME")
  endif()

  if(NOT PARSED_ARGS_HEADER_FILES)
    TLOC_LOG(FATAL_ERROR "You forgot to set(LIB_NAME_HEADERS ...)"
      )
  endif()

  if(PARSED_ARGS_UNPARSED_ARGS)
    TLOC_LOG(FATAL_ERROR "Unknown argument(s): ${PARSED_ARGS_UNPARSED_ARGS}")
  endif()

  # -----------------------------------------------------------------------------

  add_library(${PARSED_ARGS_LIB_NAME} INTERFACE)

  # -----------------------------------------------------------------------------

  if(NOT PARSED_ARGS_BUILD_INTERFACE)
    set(PARSED_ARGS_BUILD_INTERFACE ${${PARSED_ARGS_LIB_NAME}_SOURCE_DIR})
  endif()

  if(NOT PARSED_ARGS_INSTALL_INTERFACE)
    set(PARSED_ARGS_INSTALL_INTERFACE "include/")
  endif()

  # -----------------------------------------------------------------------------

  TLOC_LOG_LINE  (DEBUG)
  TLOC_LOG       (STATUS "Adding ${PARSED_ARGS_LIB_NAME} interface library")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_LIB_NAME} Headers          : ${PARSED_ARGS_HEADER_FILES}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_LIB_NAME} Link Libraries   : ${PARSED_ARGS_LINK_LIBS}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_LIB_NAME} Find Packages    : ${PARSED_ARGS_FIND_PACKAGES}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_LIB_NAME} Include Dirs     : ${PARSED_ARGS_INCLUDE_LIBS}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_LIB_NAME} Build Interface  : ${PARSED_ARGS_BUILD_INTERFACE}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_LIB_NAME} Install Interface: ${PARSED_ARGS_INSTALL_INTERFACE}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_LIB_NAME} CXX Standard     : ${PARSED_ARGS_CXX_STANDARD}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_LIB_NAME} CXX Standard Req : ${PARSED_ARGS_CXX_STANDARD_REQUIRED}")

  # -----------------------------------------------------------------------------

  foreach(PACKAGE ${PARSED_ARGS_FIND_PACKAGES})
    find_package(${PACKAGE} QUIET)
  endforeach()

  # -----------------------------------------------------------------------------

  target_include_directories(${PARSED_ARGS_LIB_NAME}
    INTERFACE
      $<BUILD_INTERFACE:${PARSED_ARGS_BUILD_INTERFACE}>
      $<INSTALL_INTERFACE:${PARSED_ARGS_INSTALL_INTERFACE}>
      ${PARSED_ARGS_INCLUDE_DIRS}
    )

  target_link_libraries(${PARSED_ARGS_LIB_NAME} INTERFACE
    ${PARSED_ARGS_LINK_LIBS}
    )

  if (PARSED_ARGS_CXX_STANDARD)
    set_target_properties(${PARSED_ARGS_LIB_NAME}
      PROPERTIES
      CXX_STANDARD ${PARSED_ARGS_CXX_STANDARD}
    )
  endif()

  if (PARSED_ARGS_CXX_STANDARD_REQUIRED)
    set_target_properties(${PARSED_ARGS_LIB_NAME}
      PROPERTIES
      CXX_STANDARD_REQUIRED ${PARSED_ARGS_CXX_STANDARD_REQUIRED}
    )
  endif()

  install(TARGETS ${PARSED_ARGS_LIB_NAME}
    EXPORT ${PARSED_ARGS_LIB_NAME}Config
    PUBLIC_HEADER DESTINATION "include/${PARSED_ARGS_LIB_NAME}"
    )

  install(FILES ${PARSED_ARGS_HEADER_FILES}
    DESTINATION "include/${PARSED_ARGS_LIB_NAME}"

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

endfunction(tl_add_interface)
