# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/../tl_fetchcontent.cmake)

# -----------------------------------------------------------------------------

# no extra options as we want to keep this process standard
function(tl_add_sdl)

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
    set(PARSED_ARGS_GIT_REPOSITORY "https://github.com/2LoC/dep_sdl")
  endif()

  if(NOT PARSED_ARGS_GIT_TAG)
    set(PARSED_ARGS_GIT_TAG "master")
  endif()

  # -----------------------------------------------------------------------------

  tl_fetchcontent(
    PROJ_NAME sdl_ext
    PACKAGE_NAME SDL2
    TARGET_NAME SDL2
    NAMESPACE SDL2::
    GIT_REPOSITORY "${PARSED_ARGS_GIT_REPOSITORY}"
    GIT_TAG ${PARSED_ARGS_GIT_TAG}
    QUIET OFF
  )

  # -----------------------------------------------------------------------------
  # since we could be either finding the package or fetching it, we need to
  # provide a standard include directory that works in all cases

  find_package(SDL2 QUIET)
  if (SDL2_FOUND)
    get_target_property(SDL2_INCLUDE_DIRECTORIES SDL2::SDL2 INTERFACE_INCLUDE_DIRECTORIES)
    set(SDL2_INCLUDE_DIR "${SDL2_INCLUDE_DIRECTORIES}/SDL2")
  else()
    set(SDL2_INCLUDE_DIR "${SDL2_SOURCE_DIR}/include/")
  endif()

  set(SDL2_INCLUDE_DIRS "$<INSTALL_INTERFACE:include/SDL2>;$<BUILD_INTERFACE:${SDL2_INCLUDE_DIR}>" PARENT_SCOPE)

endfunction()
