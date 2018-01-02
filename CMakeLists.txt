# -----------------------------------------------------------------------------

cmake_minimum_required(VERSION 3.1)

project(tl_base_ci)

# -----------------------------------------------------------------------------

set(LIB_NAME tl_base_ci)
set(LIB_NAMESPACE tl_base_ci::)

set(${LIB_NAME}_HEADERS
  "include/${LIB_NAME}/add_executable.cmake"
  "include/${LIB_NAME}/add_interface.cmake"
  "include/${LIB_NAME}/add_library.cmake"
  "include/${LIB_NAME}/add_ycm_config.cmake"
  "include/${LIB_NAME}/autogen.cmake"
  "include/${LIB_NAME}/common.cmake"
  "include/${LIB_NAME}/include_guard.cmake"

  "include/${LIB_NAME}/projects/add_sdl.cmake"
  )

set(${LIB_NAME}_INCLUDE_DIRECTORY "cmake/")

include("${CMAKE_SOURCE_DIR}/include/${LIB_NAME}/add_interface.cmake")
