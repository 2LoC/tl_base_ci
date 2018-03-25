# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/../tl_fetchcontent.cmake)

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
    set(PARSED_ARGS_GIT_TAG "master")
  endif()

  # -----------------------------------------------------------------------------

  tl_fetchcontent(
    PROJ_NAME sdl_ext
    PACKAGE_NAME SDL2
    GIT_REPOSITORY "https://github.com/2LoC/dep_sdl"
    GIT_TAG ${PARSED_ARGS_GIT_TAG}
    QUIET OFF
  )

endfunction()
