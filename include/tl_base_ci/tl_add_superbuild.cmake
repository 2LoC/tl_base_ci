# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/tl_common.cmake)

# -----------------------------------------------------------------------------

function(tl_add_superbuild)

  # -----------------------------------------------------------------------------

  set(options "")
  set(one_value_args
    DESTINATION
    )
  set(multi_value_args "")

  cmake_parse_arguments(PARSED_ARGS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN} )

  # -----------------------------------------------------------------------------
  # Error Checking

  if(NOT PARSED_ARGS_DESTINATION)
    TLOC_LOG(FATAL_ERROR "Destination is required for superbuild.")
  endif()

  TLOC_SANITIZE_AND_CHECK_DIRECTORY(${PARSED_ARGS_DESTINATION} PARSED_ARGS_DESTINATION)

  if(PARSED_ARGS_UNPARSED_ARGS)
    TLOC_LOG(FATAL_ERROR "Unknown argument(s): ${PARSED_ARGS_UNPARSED_ARGS}")
  endif()

  # -----------------------------------------------------------------------------

  set(FILE_NAME "CMakeLists.txt")
  set(FILE_DEST "${PARSED_ARGS_DESTINATION}/${FILE_NAME}")

  # -----------------------------------------------------------------------------

  TLOC_LOG_LINE  (STATUS)
  TLOC_LOG       (STATUS "Writing ${FILE_NAME} Superbuild to ${PARSED_ARGS_DESTINATION} ...")

  # -----------------------------------------------------------------------------

  file(WRITE ${FILE_DEST}
"\
# ----------------------------------
# auto-generated file, do not modify
# ----------------------------------

# -----------------------------------------------------------------------------

# You should not be modiying anything in this file. Instead, you should be
# using \"include/CMakeLists.txt\" file for your project where you will have
# access to tl_base_ci library

# -----------------------------------------------------------------------------

cmake_minimum_required(VERSION 3.1)

# -----------------------------------------------------------------------------

get_cmake_property(vars CACHE_VARIABLES)
foreach(var \${vars})
  get_property(currentHelpString CACHE \"\${var}\" PROPERTY HELPSTRING)
	if(\"\${currentHelpString}\" MATCHES \"No help, variable specified on the command line.\" OR \"\${currentHelpString}\" STREQUAL \"\")
		list(APPEND CL_ARGS \"-D\${var}=\${\${var}}\")
	endif()
endforeach()

# -----------------------------------------------------------------------------

project(SuperBuild)

# -----------------------------------------------------------------------------

include(ExternalProject)
find_package(tl_base_ci QUIET)

if(NOT tl_base_ci_FOUND)
  message(STATUS \"tl_base_ci NOT FOUND. Source will be downloaded.\")

  ExternalProject_Add(tl_base_ci_EXT
    GIT_REPOSITORY \"https://github.com/2LoC/tl_base_ci\"
    GIT_TAG \"master\"

    CMAKE_ARGS \${CL_ARGS}
  )
else()
  message(STATUS \"tl_base_ci FOUND: \${tl_base_ci_DIR}\")

  ExternalProject_Add(tl_base_ci_EXT
    BINARY_DIR \"\${tl_base_ci_DIR}\"
    SOURCE_DIR \"\${tl_base_ci_DIR}\"
    BUILD_COMMAND \"make\"
    CONFIGURE_COMMAND \"\"
    DOWNLOAD_COMMAND \"\"

    CMAKE_ARGS \${CL_ARGS}
  )
endif()

# -----------------------------------------------------------------------------

# get the current directory name, which will be this project's external
# build name
string(REPLACE \"/\" \";\" PATH_LIST \"\${CMAKE_SOURCE_DIR}\")
list(REVERSE PATH_LIST)
list(GET PATH_LIST 0 PROJ_NAME)

ExternalProject_Add(\${PROJ_NAME}_EXT
  SOURCE_DIR \"\${CMAKE_SOURCE_DIR}/include/\"

  CMAKE_ARGS \${CL_ARGS}
  )

add_dependencies(\${PROJ_NAME}_EXT tl_base_ci_EXT)

# -----------------------------------------------------------------------------
")

  # -----------------------------------------------------------------------------

  TLOC_LOG_NEWLINE(STATUS)

  # -----------------------------------------------------------------------------

endfunction(tl_add_superbuild)
