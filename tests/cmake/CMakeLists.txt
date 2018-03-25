cmake_minimum_required(VERSION 3.11)

project(tl_base_ci_tests)

include("${CMAKE_SOURCE_DIR}/../../include/tl_base_ci/projects/tl_add_catch.cmake")
include("${CMAKE_SOURCE_DIR}/../../include/tl_base_ci/tl_add_ycm_config.cmake")

tl_add_catch()
tl_add_ycm_config(DESTINATION ${CMAKE_SOURCE_DIR})

enable_testing()
add_subdirectory("include/fibonacci")
add_subdirectory("include/factorial")
add_subdirectory("include/fibonacci_test")
#add_subdirectory("include/factorial_test") # standalone, to test find_package
