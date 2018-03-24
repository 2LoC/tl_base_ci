# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/tl_common.cmake)

# -----------------------------------------------------------------------------

function(tl_add_travis)

  # -----------------------------------------------------------------------------
  # supported compilers

  INSERT_INTO_MAP(LINUX_COMPILERS "clang-3.5" "clang")
  INSERT_INTO_MAP(LINUX_COMPILERS "clang-3.6" "clang")
  INSERT_INTO_MAP(LINUX_COMPILERS "clang-3.8" "clang")
  INSERT_INTO_MAP(LINUX_COMPILERS "clang-3.9" "clang")
  INSERT_INTO_MAP(LINUX_COMPILERS "clang-4.0" "clang")
  INSERT_INTO_MAP(LINUX_COMPILERS "clang-5.0" "clang")

  INSERT_INTO_MAP(LINUX_COMPILER_ENV "clang-3.5" "clang++-3.5")
  INSERT_INTO_MAP(LINUX_COMPILER_ENV "clang-3.6" "clang++-3.6")
  INSERT_INTO_MAP(LINUX_COMPILER_ENV "clang-3.8" "clang++-3.8")
  INSERT_INTO_MAP(LINUX_COMPILER_ENV "clang-3.9" "clang++-3.9")
  INSERT_INTO_MAP(LINUX_COMPILER_ENV "clang-4.0" "clang++-4.0")
  INSERT_INTO_MAP(LINUX_COMPILER_ENV "clang-5.0" "clang++-5.0")

  # -----------------------------------------------------------------------------

  set(options
    SUDO
    APT_GET_INSTALL_GFX
    )
  set(one_value_args
    DESTINATION
    LANGUAGE
    )
  set(multi_value_args
    LINUX_COMPILERS
    OSX_COMPILERS # not yet supported
    BEFORE_INSTALL
    SCRIPT
    )

  cmake_parse_arguments(PARSED_ARGS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN} )

  # -----------------------------------------------------------------------------
  # Error Checking

  if(NOT PARSED_ARGS_LANGUAGE)
    set(PARSED_ARGS_LANGUAGE cpp)
  endif()

  if(NOT PARSED_ARGS_DESTINATION)
    set(PARSED_ARGS_DESTINATION ${CMAKE_SOURCE_DIR})
  endif()

  TLOC_SANITIZE_AND_CHECK_DIRECTORY(${PARSED_ARGS_DESTINATION} PARSED_ARGS_DESTINATION)

  if(NOT PARSED_ARGS_LINUX_COMPILERS)
    set(PARSED_ARGS_LINUX_COMPILERS "clang-3.8")
  endif()

  if(PARESD_ARGS_OSX_COMPILERS)
    TLOC_LOG(WARNING "OSX compiler support not yet implemented")
  endif()

  if(PARSED_ARGS_UNPARSED_ARGS)
    TLOC_LOG(FATAL_ERROR "Unknown argument(s): ${PARSED_ARGS_UNPARSED_ARGS}")
  endif()

  # -----------------------------------------------------------------------------

  set(FILE_NAME ".travis.yml")
  set(FILE_DEST "${PARSED_ARGS_DESTINATION}/${FILE_NAME}")

  # -----------------------------------------------------------------------------

  TLOC_LOG_LINE  (STATUS)
  TLOC_LOG       (STATUS "Writing ${FILE_NAME} to ${PARSED_ARGS_DESTINATION} ...")
  TLOC_LOG_DETAIL(STATUS "sudo           : ${PARSED_ARGS_SUDO}")
  TLOC_LOG_DETAIL(STATUS "language       : ${PARSED_ARGS_LANGUAGE}")
  TLOC_LOG_DETAIL(STATUS "linux compilers: ${PARSED_ARGS_LINUX_COMPILERS}")
  TLOC_LOG_DETAIL(STATUS "apt-get gfx    : ${PARSED_ARGS_APT_GET_INSTALL_GFX}")
  TLOC_LOG_DETAIL(STATUS "before install : ${PARSED_ARGS_BEFORE_INSTALL}")
  TLOC_LOG_DETAIL(STATUS "script         : \n${PARSED_ARGS_SCRIPT}")

  # -----------------------------------------------------------------------------

  # CMake v3.11 will have to be installed manually until Travis CI upgrades
  # it's CMake install
  set(CMAKE_EXEC_VERSION "v3.11")
  set(CMAKE_EXEC_VERSION_SH "cmake-3.11.0-rc4-Linux-x86_64.sh")

  # -----------------------------------------------------------------------------

  set(TRAVIS_SUDO "false")
  if (PARSED_ARGS_SUDO)
    set(TRAVIS_SUDO "true")
  endif()

  if(PARSED_ARGS_APT_GET_INSTALL_GFX)
    set(TRAVIS_APT_GET_INSTALL_GFX
"\
  - sudo apt-get install -y libglew-dev
  - sudo apt-get install -y libx11-dev
  - sudo apt-get install -y xorg-dev libglu1-mesa-dev\
"
      )
  endif()

  set(TRAVIS_APT_GET_UPDATE
"\
  - sudo apt-get update -qq
  - sudo apt-get install -y\
"
  )

set(TRAVIS_CMAKE_UPDATE
"\
  - mkdir $HOME/usr
  - export PATH=\"$HOME/usr/bin:$PATH\"
  - wget https://cmake.org/files/${CMAKE_EXEC_VERSION}/${CMAKE_EXEC_VERSION_SH}
  - chmod +x ${CMAKE_EXEC_VERSION_SH}
  - ./${CMAKE_EXEC_VERSION_SH} --prefix=$HOME/usr --exclude-subdir --skip-license
"
  )

  # -----------------------------------------------------------------------------

  file(WRITE ${FILE_DEST}
"\
# ----------------------------------
# auto-generated file, do not modify
# ----------------------------------

sudo: ${TRAVIS_SUDO}
language: ${PARSED_ARGS_LANGUAGE}

common_sources: &all_sources
  - ubuntu-toolchain-r-test
  - llvm-toolchain-trusty
  - llvm-toolchain-trusty-3.9
  - llvm-toolchain-trusty-4.0
  - llvm-toolchain-trusty-5.0

matrix:
  include:"
  )

foreach(COMPILER IN LISTS PARSED_ARGS_LINUX_COMPILERS)

  if(NOT LINUX_COMPILERS_${COMPILER})
    TLOC_LOG(WARNING "Unsupported compiler requested: ${COMPILER}")
  endif()

  file(APPEND ${FILE_DEST}
"
    - os: linux
      compiler: ${LINUX_COMPILERS_${COMPILER}}
      addons:
        apt:
          sources: *all_sources
          packages:
            - ${COMPILER}
      env: COMPILER='${LINUX_COMPILER_ENV_${COMPILER}}'

"
  )
endforeach()

file(APPEND ${FILE_DEST}
"\
before_install:
${TRAVIS_APT_GET_UPDATE}
${TRAVIS_APT_GET_INSTALL_GFX}
${TRAVIS_CMAKE_UPDATE}
${PARSED_ARGS_BEFORE_INSTALL}

script:
${PARSED_ARGS_SCRIPT}"
  )

  # -----------------------------------------------------------------------------

  TLOC_LOG_NEWLINE(STATUS)

  # -----------------------------------------------------------------------------

endfunction(tl_add_travis)
