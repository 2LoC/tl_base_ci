set(EXE_NAME fibonacci_test)
set(EXE_NAMESPACE tl_base_ci::)

set(${EXE_NAME}_LINK_LIBRARIES
  fibonacci
  )

set(${EXE_NAME}_HEADERS
  "main.h"
  )

set(${EXE_NAME}_SOURCE_FILES
  "main.cpp"
  )

include("${CMAKE_SOURCE_DIR}/../../include/tl_base_ci/add_executable.cmake")

add_test(${EXE_NAME}_test ${EXE_NAME})
