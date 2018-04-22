# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/../tl_fetchcontent.cmake)

# -----------------------------------------------------------------------------

# no extra options as we want to keep this process standard
function(tl_add_catch)

  # -----------------------------------------------------------------------------

  set(options "")
  set(one_value_args
    GIT_REPOSITORY
    GIT_TAG
    )
  set(multi_value_args "")

  cmake_parse_arguments(PARSED_ARGS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN} )

  # -----------------------------------------------------------------------------

  if(NOT PARSED_ARGS_GIT_REPOSITORY)
    set(PARSED_ARGS_GIT_REPOSITORY "https://github.com/2LoC/dep_catch")
  endif()

  if(NOT PARSED_ARGS_GIT_TAG)
    set(PARSED_ARGS_GIT_TAG "master")
  endif()

  # -----------------------------------------------------------------------------

  tl_fetchcontent(
    PROJ_NAME catch_ext
    PACKAGE_NAME Catch2
    TARGET_NAME Catch2::Catch
    NAMESPACE Catch2::
    GIT_REPOSITORY "${PARSED_ARGS_GIT_REPOSITORY}"
    GIT_TAG ${PARSED_ARGS_GIT_TAG}
    CL_ARGS "-DBUILD_TESTING=OFF"
    QUIET OFF
  )

endfunction()
