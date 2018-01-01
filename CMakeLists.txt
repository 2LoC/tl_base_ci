# -----------------------------------------------------------------------------

cmake_minimum_required(VERSION 3.1)

project(tl_base_ci)

# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/cmake/common.cmake)

# -----------------------------------------------------------------------------

install(DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/cmake/"
  DESTINATION "${TLOC_INSTALL_PREFIX}/tl_base_ci/"
  )
