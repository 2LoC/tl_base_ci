# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/tl_common.cmake)

# -----------------------------------------------------------------------------

function(tl_add_interface)

  # -----------------------------------------------------------------------------

  set(options "")
  set(one_value_args
    LIB_NAME
    )
  set(multi_value_args
    HEADER_FILES
    INCLUDE_DIRECTORIES
    LINK_LIBRARIES
    FIND_PACKAGES
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

  TLOC_LOG_LINE  (STATUS)
  TLOC_LOG       (STATUS "Adding ${PARSED_ARGS_LIB_NAME} interface library")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_LIB_NAME} Headers       : ${PARSED_ARGS_HEADER_FILES}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_LIB_NAME} Link Libraries: ${PARSED_ARGS_LINK_LIBRARIES}")
  TLOC_LOG_DETAIL(STATUS "${PARSED_ARGS_LIB_NAME} Packages      : ${PARSED_ARGS_FIND_PACKAGES}")

  # -----------------------------------------------------------------------------

  add_library(${PARSED_ARGS_LIB_NAME} INTERFACE)

  target_include_directories(${PARSED_ARGS_LIB_NAME}
    INTERFACE
      $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include/>
      $<INSTALL_INTERFACE:include/>
      ${PARSED_ARGS_INCLUDE_DIRECTORIES}
    )

  target_link_libraries(${PARSED_ARGS_LIB_NAME} INTERFACE
    ${PARSED_ARGS_LINK_LIBRARIES}
    )

  foreach(PACKAGE ${PARSED_ARGS_FIND_PACKAGES})
    target_link_libraries(${PARSED_ARGS_LIB_NAME} INTERFACE
      ${PACKAGE}
      )
  endforeach()

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

  TLOC_LOG_LINE  (STATUS)

  # -----------------------------------------------------------------------------

endfunction(tl_add_interface)
