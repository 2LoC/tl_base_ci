# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/../tl_fetchcontent.cmake)

# -----------------------------------------------------------------------------

# no extra options as we want to keep this process standard
function(tl_add_fmt)

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
    set(PARSED_ARGS_GIT_REPOSITORY "https://github.com/2LoC/dep_fmt")
  endif()

  if(NOT PARSED_ARGS_GIT_TAG)
    set(PARSED_ARGS_GIT_TAG "master")
  endif()

  # -----------------------------------------------------------------------------

  option(FMT_INSTALL
    "fmt library will be installed" ON
    )

  # -----------------------------------------------------------------------------

  tl_fetchcontent(
    PROJ_NAME fmt_ext
    PACKAGE_NAME fmt
    GIT_REPOSITORY "${PARSED_ARGS_GIT_REPOSITORY}"
    GIT_TAG ${PARSED_ARGS_GIT_TAG}
    QUIET OFF
  )

  find_package(fmt QUIET)
  if (fmt_FOUND)
    get_target_property(FMT_INCLUDE_DIRECTORIES fmt::fmt INTERFACE_INCLUDE_DIRECTORIES)
    set(FMT_INCLUDE_DIR "${FMT_INCLUDE_DIRECTORIES}")
  else()
    set(FMT_INCLUDE_DIR "${FMT_SOURCE_DIR}/include/")
  endif()

  set(FMT_INCLUDE_DIRS "$<INSTALL_INTERFACE:include/fmt>;$<BUILD_INTERFACE:${FMT_INCLUDE_DIR}>" PARENT_SCOPE)

endfunction()
