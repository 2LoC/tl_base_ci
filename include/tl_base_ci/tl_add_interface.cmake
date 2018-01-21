# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/tl_common.cmake)

# -----------------------------------------------------------------------------
# Error Checking

if(NOT DEFINED LIB_NAME)
  TLOC_LOG(FATAL_ERROR "You forgot to set(LIB_NAME ...)")
endif()

if(NOT DEFINED ${LIB_NAME}_HEADERS )
  TLOC_LOG(FATAL_ERROR "You forgot to set(LIB_NAME_HEADERS ...)"
    )
endif()

# -----------------------------------------------------------------------------

TLOC_LOG_DETAIL(STATUS "----------------------------------------------------------")
TLOC_LOG       (STATUS "Adding ${LIB_NAME} library")
TLOC_LOG_DETAIL(STATUS "${LIB_NAME} Headers       : ${${LIB_NAME}_HEADERS}")
TLOC_LOG_DETAIL(STATUS "${LIB_NAME} Link Libraries: ${${LIB_NAME}_LINK_LIBRARIES}")
TLOC_LOG_DETAIL(STATUS "${LIB_NAME} Packages      : ${${LIB_NAME}_FIND_PACKAGES}")

# -----------------------------------------------------------------------------

add_library(${LIB_NAME} INTERFACE)

target_sources(${LIB_NAME} INTERFACE
  "${${LIB_NAM}_HEADERS}"
  )

target_include_directories(${LIB_NAME} INTERFACE
    $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include/>
    $<INSTALL_INTERFACE:include/>
  )

target_link_libraries(${LIB_NAME} INTERFACE
  ${${LIB_NAME}_LINK_LIBRARIES}
  )

foreach(PACKAGE ${${LIB_NAME}_FIND_PACKAGES})
  target_link_libraries(${LIB_NAME} INTERFACE
      ${PACKAGE}
  )
endforeach()

install(TARGETS ${LIB_NAME}
  EXPORT ${LIB_NAME}Config
  PUBLIC_HEADER DESTINATION "include/${LIB_NAME}"
  )

install(DIRECTORY ${${LIB_NAME}_INCLUDE_DIRECTORY}
  DESTINATION "include/${LIB_NAME}"

  FILE_PERMISSIONS OWNER_READ
  )

install(EXPORT ${LIB_NAME}Config
  DESTINATION "cmake/"

  PERMISSIONS OWNER_READ
  )

export(TARGETS ${LIB_NAME} FILE ${LIB_NAME}Config.cmake)
export(PACKAGE ${LIB_NAME})

# -----------------------------------------------------------------------------

TLOC_LOG_DETAIL(STATUS "----------------------------------------------------------")
