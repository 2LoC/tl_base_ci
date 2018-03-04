set(LIB_NAME fibonacci)
set(LIB_NAMESPACE tl_)

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

include("${CMAKE_SOURCE_DIR}/../../include/tl_base_ci/tl_add_library.cmake")
tl_add_library(
  LIB_NAME
    ${LIB_NAME}
  PUBLIC_HEADER_FILES
    ${${LIB_NAME}_PUBLIC_HEADERS}
  SOURCE_FILES
    ${${LIB_NAME}_SOURCE_FILES}
  BUILD_INTERFACE
    ${CMAKE_SOURCE_DIR}/include/
  INSTALL_INTERFACE
    "install/include"
  )

include("${CMAKE_SOURCE_DIR}/../../include/tl_base_ci/tl_autogen_single_include_header.cmake")
tl_autogen_single_include(
  NAME ${LIB_NAME}.h
  DESTINATION ${CMAKE_CURRENT_LIST_DIR}
  )
