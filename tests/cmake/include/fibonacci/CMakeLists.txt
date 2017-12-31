set(LIB_NAME fibonacci)
set(LIB_NAMESPACE tl_base_ci::)

set(${LIB_NAME}_PUBLIC_HEADERS
  "fib_int.h"
  "fib_float.h"
  "fib_double.h"
  "fib_long_double.h"
  )

set(${LIB_NAME}_SOURCE_FILES
  "fib_int.cpp"
  "fib_float.cpp"
  "fib_double.cpp"
  "fib_long_double.cpp"
  )

include("${CMAKE_SOURCE_DIR}/../../cmake/add_library.cmake")
