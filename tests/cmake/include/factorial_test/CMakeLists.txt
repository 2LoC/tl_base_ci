cmake_minimum_required(VERSION 3.1)

project(factorial_test)

include("${CMAKE_SOURCE_DIR}/../../../../include/tl_base_ci/tl_common.cmake")
include("${CMAKE_SOURCE_DIR}/../../../../include/tl_base_ci/tl_add_ycm_config.cmake")
include("${CMAKE_SOURCE_DIR}/../../../../include/tl_base_ci/tl_add_executable.cmake")

set(EXE_NAME factorial_test)
set(EXE_NAMESPACE tl_)

tl_add_executable(
  EXE_NAME ${EXE_NAME}
  SOURCE_FILES "main.cpp"
  PUBLIC_FIND_PACKAGES "factorial"
  )

enable_testing()
add_test(${EXE_NAME}_test ${EXE_NAME})
