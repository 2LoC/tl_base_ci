set(EXE_NAME fibonacci_test)
set(EXE_NAMESPACE tl_)

include("${CMAKE_SOURCE_DIR}/../../include/tl_base_ci/tl_add_executable.cmake")
tl_add_executable(
  EXE_NAME ${EXE_NAME}
  HEADER_FILES "main.h"
  SOURCE_FILES "main.cpp"
  LINK_LIBRARIES "fibonacci"
  )

add_test(${EXE_NAME}_test ${EXE_NAME})
