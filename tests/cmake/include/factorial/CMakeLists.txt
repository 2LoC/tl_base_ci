set(LIB_NAME factorial)
set(LIB_NAMESPACE tl_base_ci::)
set(${LIB_NAME}_INTERFACE ON)

set(${LIB_NAME}_HEADERS
  "factorial.h"
  )

include("${CMAKE_SOURCE_DIR}/../../cmake/add_interface.cmake")
