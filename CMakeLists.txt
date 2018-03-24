# -----------------------------------------------------------------------------

cmake_minimum_required(VERSION 3.11)

# -----------------------------------------------------------------------------

set(LIB_NAME tl_base_ci)
set(INCLUDE_DIR "${CMAKE_CURRENT_LIST_DIR}/include/${LIB_NAME}")

include("${INCLUDE_DIR}/tl_common.cmake")
include("${INCLUDE_DIR}/tl_add_interface.cmake")
include("${INCLUDE_DIR}/tl_add_travis.cmake")
include("${INCLUDE_DIR}/tl_add_gitignore.cmake")

# -----------------------------------------------------------------------------

project(tl_base_ci)

# -----------------------------------------------------------------------------

set(${LIB_NAME}_HEADERS
  "${INCLUDE_DIR}/tl_add_executable.cmake"
  "${INCLUDE_DIR}/tl_add_gitignore.cmake"
  "${INCLUDE_DIR}/tl_add_interface.cmake"
  "${INCLUDE_DIR}/tl_add_library.cmake"
  "${INCLUDE_DIR}/tl_add_superbuild.cmake"
  "${INCLUDE_DIR}/tl_add_travis.cmake"
  "${INCLUDE_DIR}/tl_add_ycm_config.cmake"

  "${INCLUDE_DIR}/tl_autogen_single_include_cmake.cmake"
  "${INCLUDE_DIR}/tl_autogen_single_include_header.cmake"

  "${INCLUDE_DIR}/tl_common.cmake"

  "${INCLUDE_DIR}/tl_external_project.cmake"
  "${INCLUDE_DIR}/tl_find_package.cmake"

  "${INCLUDE_DIR}/configure_file/tl_superbuild_cmakelists.cmake"

  "${INCLUDE_DIR}/projects/tl_add_sdl.cmake"
  "${INCLUDE_DIR}/projects/tl_add_catch.cmake"
  )

# -----------------------------------------------------------------------------

tl_add_interface(
  LIB_NAME ${LIB_NAME}
  HEADER_FILES ${${LIB_NAME}_HEADERS}
  BUILD_INTERFACE "${CMAKE_CURRENT_LIST_DIR}/include/"
  )

# -----------------------------------------------------------------------------

set(TRAVIS_SCRIPT
"\
  - cd tests/cmake/
  - mkdir build
  - cd build
  - cmake -DCMAKE_CXX_COMPILER=$COMPILER -DTLOC_INSTALL_PREFIX=../install -DTLOC_DETAILED_LOGS=ON ../
  - make install
  - ctest
  - cd ..
  - cd include/factorial_test/
  - mkdir build
  - cd build
  - cmake -DCMAKE_CXX_COMPILER=$COMPILER -DTLOC_INSTALL_PREFIX=../install -DTLOC_DETAILED_LOGS=ON ../
  - make install
  - ctest
"
  )

tl_add_travis(
  LINUX_COMPILERS "clang-3.8;clang-4.0;clang-5.0"
  SCRIPT ${TRAVIS_SCRIPT}
  )

# -----------------------------------------------------------------------------

tl_add_gitignore(
  IGNORE_LIST "tests/cmake/CMakeFiles/"
  )
