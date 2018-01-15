set(LIB_NAME factorial)
set(LIB_NAMESPACE tl_base_ci::)

set(${LIB_NAME}_HEADERS
  "factorial.h"
  )

include("${CMAKE_SOURCE_DIR}/../../include/tl_base_ci/tl_add_interface.cmake")
