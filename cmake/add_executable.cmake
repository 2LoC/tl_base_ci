# Include this file to add a library in a standard tl_ way.
# See notes at eof.

# -----------------------------------------------------------------------------
# Error Checking

if(NOT DEFINED EXE_NAME)
  TLOC_LOG(FATAL_ERROR "You forgot to set(EXE_NAME ...)")
endif()

if(NOT DEFINED ${EXE_NAME}_SOURCE_FILES)
  TLOC_LOG(FATAL_ERROR "You forgot to set(EXE_NAME_SOURCE_FILES ...)")
endif()

if(NOT DEFINED EXE_NAMESPACE)
  TLOC_LOG(WARNING "You forgot to set(EXE_NAMESPACE ...)")
endif()

# -----------------------------------------------------------------------------

TLOC_LOG_DETAIL(STATUS "----------------------------------------------------------")
TLOC_LOG       (STATUS "Adding ${EXE_NAME} executable with namespace ${EXE_NAMESPACE}")
TLOC_LOG_DETAIL(STATUS "${EXE_NAME} Headers         : ${${EXE_NAME}_HEADERS}")
TLOC_LOG_DETAIL(STATUS "${EXE_NAME} Source Files    : ${${EXE_NAME}_SOURCE_FILES}")
TLOC_LOG_DETAIL(STATUS "${EXE_NAME} Link libraries  : ${${EXE_NAME}_LINK_LIBRARIES}")
TLOC_LOG_DETAIL(STATUS "${EXE_NAME} Public Packages : ${${EXE_NAME}_PUBLIC_FIND_PACKAGES}")
TLOC_LOG_DETAIL(STATUS "${EXE_NAME} Private Packages: ${${EXE_NAME}_PRIVATE_FIND_PACKAGES}")

# -----------------------------------------------------------------------------

foreach(PACKAGE ${${EXE_NAME}_PUBLIC_FIND_PACKAGES})
  find_package(${PACKAGE} REQUIRED)
endforeach()

foreach(PACKAGE ${${EXE_NAME}_PRIVATE_FIND_PACKAGES})
  find_package(${PACKAGE} REQUIRED)
endforeach()

# -----------------------------------------------------------------------------

add_executable(${EXE_NAME}
  ${${EXE_NAME}_HEADERS}
  ${${EXE_NAME}_SOURCE_FILES}
  )

target_include_directories(${EXE_NAME}
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include/>
    $<INSTALL_INTERFACE:include/>
  )

target_link_libraries(${EXE_NAME}
  PUBLIC
    ${${EXE_NAME}_LINK_LIBRARIES}
  )

foreach(PACKAGE ${${EXE_NAME}_PUBLIC_FIND_PACKAGES})
  target_link_libraries(${EXE_NAME}
    PUBLIC
      ${PACKAGE}
  )
endforeach()

foreach(PACKAGE ${${EXE_NAME}_PRIVATE_FIND_PACKAGES})
  target_link_libraries(${EXE_NAME}
    PRIVATE
      ${PACKAGE}
  )
endforeach()

install(TARGETS ${EXE_NAME}
  EXPORT ${EXE_NAME}Config
  RUNTIME       DESTINATION "bin/${EXE_NAME}/"
  )

install(EXPORT ${EXE_NAME}Config
  NAMESPACE ${EXE_NAMESPACE}
  DESTINATION "cmake/"
  )

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
