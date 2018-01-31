# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/../tl_common.cmake)
include(ExternalProject)

# -----------------------------------------------------------------------------

# no extra options as we want to keep this process standard
function(tl_add_sdl)

  # -----------------------------------------------------------------------------

  ExternalProject_Add(sdl
    GIT_REPOSITORY "https://github.com/2LoC/dep_sdl"

    # last known working build
    GIT_TAG "2f2d79f3428a26031c4b67c824571bef1633e58d"

    SOURCE_DIR "${TLOC_DEP_SOURCE_DIR}/sdl"

    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX=${TLOC_INSTALL_PREFIX}/sdl
      -DCMAKE_DEBUG_POSTFIX=_d

    TEST_COMMAND ""
    )

endfunction()
