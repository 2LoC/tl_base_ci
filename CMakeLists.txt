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
  "include/${LIB_NAME}/tl_autogen_single_include_cmake.cmake"
  "include/${LIB_NAME}/tl_autogen_single_include_header.cmake"
  "include/${LIB_NAME}/tl_common.cmake"
  "include/${LIB_NAME}/tl_external_project.cmake"
  "include/${LIB_NAME}/tl_find_package.cmake"
  "include/${LIB_NAME}/tl_include_guard.cmake"

  "include/${LIB_NAME}/projects/tl_add_sdl.cmake"
  )

# -----------------------------------------------------------------------------

include("${CMAKE_SOURCE_DIR}/include/${LIB_NAME}/tl_add_interface.cmake")

tl_add_interface(
  LIB_NAME ${LIB_NAME}
  HEADER_FILES ${${LIB_NAME}_HEADERS}
  )

# -----------------------------------------------------------------------------

include("${CMAKE_SOURCE_DIR}/include/${LIB_NAME}/tl_add_travis.cmake")

set(TRAVIS_SCRIPT
"\
  - cd tests/cmake/
  - mkdir build
  - cd build
  - cmake -DCMAKE_CXX_COMPILER=$COMPILER -DTLOC_INSTALL_PREFIX=../install -DTLOC_ENABLED_DETAILED_LOGS=ON ../
  - make install
  - ctest
  - cd ..
  - cd include/factorial_test/
  - mkdir build
  - cd build
  - cmake -DCMAKE_CXX_COMPILER=$COMPILER -DTLOC_INSTALL_PREFIX=../install -DTLOC_ENABLED_DETAILED_LOGS=ON ../
  - make install
  - ctest
"
  )

tl_add_travis(
  LINUX_COMPILERS "clang-3.8;clang-4.0;clang-5.0"
  SCRIPT ${TRAVIS_SCRIPT}
  )
