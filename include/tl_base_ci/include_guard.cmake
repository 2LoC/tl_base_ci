# /IncludeGuard.cmake
#
# Include this file and invoke cmake_include_guard to prevent the CMake script
# this file is included into from being parsed multiple times.
#
# You can use SET_MODULE_PATH to add this file to the CMAKE_MODULE_PATH too.
#
# See /LICENCE.md for Copyright information

macro (cmake_include_guard)

    if (DEFINED "_INCLUDE_GUARD_${CMAKE_CURRENT_LIST_FILE}")

        return ()

    endif ()

    set ("_INCLUDE_GUARD_${CMAKE_CURRENT_LIST_FILE}" ENTERED)

    foreach (ARG ${ARGN})

        if ("${ARG}" STREQUAL "SET_MODULE_PATH")

            set (CMAKE_MODULE_PATH
                 "${CMAKE_CURRENT_LIST_DIR}"
                 ${CMAKE_MODULE_PATH})  # NOLINT:correctness/quotes
            break ()

        endif ()

    endforeach ()

endmacro ()
