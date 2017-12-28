set(LIB_NAME TestLib)
set(LIB_NAMESPACE tl_base_ci::)

set(${LIB_NAME}_PUBLIC_HEADERS
  "A.h"
  "B.h"
  "C.h"
  "D.h"
  )

set(${LIB_NAME}_SOURCE_FILES
  "A.cpp"
  "B.cpp"
  "C.cpp"
  "D.cpp"
  )

include("${CMAKE_SOURCE_DIR}/../../cmake/add_library.cmake")
