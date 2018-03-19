# -----------------------------------------------------------------------------

include_guard(GLOBAL)
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

  set(INCLUDE_FILE_NAME "tl_include_common.cmake")
  set(INCLUDE_FILE_DEST "${PARSED_ARGS_DESTINATION}/${INCLUDE_FILE_NAME}")

  # -----------------------------------------------------------------------------

  TLOC_LOG_LINE  (STATUS)
  TLOC_LOG       (STATUS "Writing ${FILE_NAME} Superbuild to ${PARSED_ARGS_DESTINATION} ...")
  TLOC_LOG       (STATUS "Writing ${INCLUDE_FILE_NAME} helper to ${PARSED_ARGS_DESTINATION} ...")

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

if(EXISTS \"${PARSED_ARGS_DESTINATION}/CMakeLists_Pre.cmake\")
  include(\"${PARSED_ARGS_DESTINATION}/CMakeLists_Pre.cmake\")
endif()

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

include(${INCLUDE_FILE_DEST})

# -----------------------------------------------------------------------------

if(EXISTS \"${PARSED_ARGS_DESTINATION}/CMakeLists_Post.cmake\")
  include(\"${PARSED_ARGS_DESTINATION}/CMakeLists_Post.cmake\")
endif()

# -----------------------------------------------------------------------------
")

  # -----------------------------------------------------------------------------

  file(WRITE ${INCLUDE_FILE_DEST}
"\
# ----------------------------------
# auto-generated file, do not modify
# ----------------------------------

# -----------------------------------------------------------------------------

# This helper file allows you to include tl_common.cmake using the same function
# found inside tl_common.cmake. Note that this file may be updated automatically
# by tl_add_superbuild.cmake

# -----------------------------------------------------------------------------

find_package(tl_base_ci REQUIRED)
get_target_property(tl_base_ci_INCLUDE_DIRECTORIES tl_base_ci
  INTERFACE_INCLUDE_DIRECTORIES
  )

# -----------------------------------------------------------------------------
# same function found in tl_common.cmake

function(TLOC_INCLUDE_TEMP FILE PATHS)
  foreach(PATH \${PATHS})
    set(FULL_PATH \${PATH}\${FILE})
    if (EXISTS \${FULL_PATH})
      include(\${FULL_PATH})
      return()
    endif()
  endforeach()
  message(FATAL_ERROR \"Could not find file \${FILE} to include in paths \${PATHS}\")
endfunction()

TLOC_INCLUDE_TEMP(\"/tl_base_ci/tl_common.cmake\" \${tl_base_ci_INCLUDE_DIRECTORIES})

# -----------------------------------------------------------------------------
")

  # -----------------------------------------------------------------------------

  TLOC_LOG_NEWLINE(STATUS)

  # -----------------------------------------------------------------------------

endfunction(tl_add_superbuild)
