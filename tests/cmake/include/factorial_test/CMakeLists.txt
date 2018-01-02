cmake_minimum_required(VERSION 3.1)

project(factorial_test)

include("${CMAKE_SOURCE_DIR}/../../../../include/tl_base_ci/common.cmake")
include("${CMAKE_SOURCE_DIR}/../../../../include/tl_base_ci/add_ycm_config.cmake")

set(EXE_NAME factorial_test)
set(EXE_NAMESPACE tl_base_ci::)

set(${EXE_NAME}_PUBLIC_FIND_PACKAGES
  factorial
  )

set(${EXE_NAME}_SOURCE_FILES
  "main.cpp"
  )

include("${CMAKE_SOURCE_DIR}/../../../../include/tl_base_ci/add_executable.cmake")

enable_testing()
add_test(${EXE_NAME}_test ${EXE_NAME})
