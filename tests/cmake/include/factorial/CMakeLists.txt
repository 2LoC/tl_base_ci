set(LIB_NAME factorial)
set(LIB_NAMESPACE tl_)

set(${LIB_NAME}_HEADERS
  "factorial.h"
  )

include("${CMAKE_SOURCE_DIR}/../../include/tl_base_ci/tl_add_interface.cmake")
tl_add_interface(
  LIB_NAME
    ${LIB_NAME}
  HEADER_FILES
    ${${LIB_NAME}_HEADERS}
  BUILD_INTERFACE
    ${CMAKE_SOURCE_DIR}/include/
  INSTALL_INTERFACE
    "install/include"

  )
