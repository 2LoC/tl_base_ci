# -----------------------------------------------------------------------------

include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/tl_common.cmake)

# -----------------------------------------------------------------------------
# Error Checking

if(NOT DEFINED PACKAGE_NAME)
  TLOC_LOG(FATAL_ERROR "You forgot to set(EXT_LIB_NAME ...)")
endif()
