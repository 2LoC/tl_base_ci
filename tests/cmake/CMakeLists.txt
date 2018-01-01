cmake_minimum_required(VERSION 3.1)

project(tl_base_ci_tests)

include("${CMAKE_SOURCE_DIR}/../../cmake/projects/add_sdl.cmake")
include("${CMAKE_SOURCE_DIR}/../../cmake/add_ycm_config.cmake")

enable_testing()
add_subdirectory("include/fibonacci")
add_subdirectory("include/factorial")
add_subdirectory("include/fibonacci_test")
#add_subdirectory("include/factorial_test") # standalone, to test find_package
