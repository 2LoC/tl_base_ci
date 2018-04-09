cmake_minimum_required(VERSION 3.11)

project(factorial_test)

include("${CMAKE_SOURCE_DIR}/../../../../include/tl_base_ci/tl_common.cmake")
include("${CMAKE_SOURCE_DIR}/../../../../include/tl_base_ci/tl_add_ycm_config.cmake")
include("${CMAKE_SOURCE_DIR}/../../../../include/tl_base_ci/tl_add_executable.cmake")
include("${CMAKE_SOURCE_DIR}/../../../../include/tl_base_ci/projects/tl_add_catch.cmake")

set(EXE_NAME factorial_test)
set(EXE_NAMESPACE tl_)

tl_add_catch()
tl_add_ycm_config()

tl_add_executable(
  EXE_NAME ${EXE_NAME}
  SOURCE_FILES "main.cpp"
  FIND_PACKAGES "factorial"
  LINK_LIBS "Catch;factorial"
  )

enable_testing()
add_test(${EXE_NAME}_test ${EXE_NAME})
