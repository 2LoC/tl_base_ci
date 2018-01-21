# -----------------------------------------------------------------------------

cmake_minimum_required(VERSION 3.1)

project(tl_base_ci)

# -----------------------------------------------------------------------------

set(LIB_NAME tl_base_ci)

set(${LIB_NAME}_HEADERS
  "include/${LIB_NAME}/tl_add_executable.cmake"
  "include/${LIB_NAME}/tl_add_interface.cmake"
  "include/${LIB_NAME}/tl_add_library.cmake"
  "include/${LIB_NAME}/tl_add_ycm_config.cmake"
  "include/${LIB_NAME}/tl_autogen.cmake"
  "include/${LIB_NAME}/tl_common.cmake"
  "include/${LIB_NAME}/tl_include_guard.cmake"

  "include/${LIB_NAME}/projects/tl_add_sdl.cmake"
  )

set(${LIB_NAME}_INCLUDE_DIRECTORY "include/${LIB_NAME}/")

include("${CMAKE_SOURCE_DIR}/include/${LIB_NAME}/tl_add_interface.cmake")
