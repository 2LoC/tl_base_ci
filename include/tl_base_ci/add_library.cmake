# Include this file to add a library in a standard tl_ way.
# See notes at eof.

# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/common.cmake)

# -----------------------------------------------------------------------------
# Error Checking

if(NOT DEFINED LIB_NAME)
  TLOC_LOG(FATAL_ERROR "You forgot to set(LIB_NAME ...)")
endif()

if(NOT DEFINED ${LIB_NAME}_PUBLIC_HEADERS)
  TLOC_LOG(FATAL_ERROR "You forgot to set(LIB_NAME_PUBLIC_HEADERS ...)")
endif()

if(NOT DEFINED LIB_NAMESPACE)
  TLOC_LOG(WARNING "You forgot to set(LIB_NAMESPACE ...)")
endif()

# -----------------------------------------------------------------------------

TLOC_LOG_DETAIL(STATUS "----------------------------------------------------------")
TLOC_LOG       (STATUS "Adding ${LIB_NAME} library with namespace ${LIB_NAMESPACE}")
TLOC_LOG_DETAIL(STATUS "${LIB_NAME} Public Headers  : ${${LIB_NAME}_PUBLIC_HEADERS}")
TLOC_LOG_DETAIL(STATUS "${LIB_NAME} Private Headers : ${${LIB_NAME}_PRIVATE_HEADERS}")
TLOC_LOG_DETAIL(STATUS "${LIB_NAME} Source Files    : ${${LIB_NAME}_SOURCE_FILES}")
TLOC_LOG_DETAIL(STATUS "${LIB_NAME} Public Libs     : ${${LIB_NAME}_PUBLIC_LINK_LIBRARIES}")
TLOC_LOG_DETAIL(STATUS "${LIB_NAME} Private Libs    : ${${LIB_NAME}_PRIVATE_LINK_LIBRARIES}")
TLOC_LOG_DETAIL(STATUS "${LIB_NAME} Public Packages : ${${LIB_NAME}_PUBLIC_FIND_PACKAGES}")
TLOC_LOG_DETAIL(STATUS "${LIB_NAME} Private Packages: ${${LIB_NAME}_PRIVATE_FIND_PACKAGES}")

# -----------------------------------------------------------------------------

add_library(${LIB_NAME}
  ${${LIB_NAME}_PUBLIC_HEADERS}
  ${${LIB_NAME}_PRIVATE_HEADERS}
  ${${LIB_NAME}_SOURCE_FILES}
  )

set_target_properties(${LIB_NAME}
  PROPERTIES PUBLIC_HEADER "${${LIB_NAME}_PUBLIC_HEADERS}"
  )

target_include_directories(${LIB_NAME}
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include/>
    $<INSTALL_INTERFACE:include/>
  )

target_link_libraries(${LIB_NAME}
  PUBLIC
    ${${LIB_NAME}_PUBLIC_LINK_LIBRARIES}
  PRIVATE
    ${${LIB_NAME}_PRIVATE_LINK_LIBRARIES}
  )

foreach(PACKAGE ${${LIB_NAME}_PUBLIC_FIND_PACKAGES})
  target_link_libraries(${LIB_NAME}
    PUBLIC
      ${PACKAGE}
  )
endforeach()

foreach(PACKAGE ${${LIB_NAME}_PRIVATE_FIND_PACKAGES})
  target_link_libraries(${LIB_NAME}
    PRIVATE
      ${PACKAGE}
  )
endforeach()

install(TARGETS ${LIB_NAME}
  EXPORT ${LIB_NAME}Config
  PUBLIC_HEADER DESTINATION "include/${LIB_NAME}"
  RUNTIME       DESTINATION "bin/${LIB_NAME}/"
  LIBRARY       DESTINATION "lib/${LIB_NAME}/"
  ARCHIVE       DESTINATION "lib/${LIB_NAME}/static/"

  PERMISSIONS OWNER_READ
  )

install(EXPORT ${LIB_NAME}Config
  NAMESPACE ${LIB_NAMESPACE}
  DESTINATION "cmake/"

  PERMISSIONS OWNER_READ
  )

export(TARGETS ${LIB_NAME} FILE ${LIB_NAME}Config.cmake)
export(PACKAGE ${LIB_NAME})

# -----------------------------------------------------------------------------

TLOC_LOG_DETAIL(STATUS "----------------------------------------------------------")

# -----------------------------------------------------------------------------

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
