# -----------------------------------------------------------------------------

set(TLOC_DEP_SOURCE_DIR
  "${CMAKE_BINARY_DIR}" CACHE
  PATH "Dependencies will be cloned/downloaded here"
  )

set(TLOC_INSTALL_PREFIX
  "${CMAKE_INSTALL_PREFIX}" CACHE
  PATH "Projects (including dependencies) will be installed here"
  )

option(TLOC_DEP_DISABLE_TESTS
  "Disable tests for all dependencies" ON
  )

set(TLOC_CXX_COMPILER_PATH
  "${CMAKE_CXX_COMPILER}" CACHE
  PATH "Path to the C++ compiler"
  )

# -----------------------------------------------------------------------------
