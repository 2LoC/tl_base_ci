# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/../tl_external_project.cmake)

# -----------------------------------------------------------------------------

# no extra options as we want to keep this process standard
function(tl_add_sdl)

  # -----------------------------------------------------------------------------

  set(options "")
  set(one_value_args
    GIT_TAG
    )
  set(multi_value_args "")

  cmake_parse_arguments(PARSED_ARGS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN} )

  # -----------------------------------------------------------------------------

  if(NOT PARSED_ARGS_GIT_TAG)
    set(PARSED_ARGS_GIT_TAG "2f2d79f3428a26031c4b67c824571bef1633e58d")
  endif()

  # -----------------------------------------------------------------------------

  tl_external_project_add(
    PROJ_NAME sdl_EXT
    PACKAGE_NAME SDL2
    GIT_REPOSITORY "https://github.com/2LoC/dep_sdl"
    GIT_TAG ${PARSED_ARGS_GIT_TAG}
  )

endfunction()
