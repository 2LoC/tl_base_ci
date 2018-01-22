# -----------------------------------------------------------------------------

include(${CMAKE_CURRENT_LIST_DIR}/tl_common.cmake)

# -----------------------------------------------------------------------------
# Autogenerate all inclusive header

function(tl_autogen_single_include
    HEADER_NAME
    HEADER_PATH
  )

  set(FULL_PATH "${HEADER_PATH}/${HEADER_NAME}")
  file(REMOVE "${FULL_PATH}")
  file(GLOB_RECURSE ALL_HEADERS RELATIVE "${HEADER_PATH}" *.h)

# -----------------------------------------------------------------------------

TLOC_LOG_LINE  (STATUS)
TLOC_LOG       (STATUS "Creating all inclusive CPP header: ${FULL_PATH}")
TLOC_LOG_DETAIL(STATUS "Headers found: ${ALL_HEADERS}")

# -----------------------------------------------------------------------------

  file(WRITE "${FULL_PATH}"
"#pragma once

// Auto generated file, DO NOT overwrite
"
  )

  foreach(HEADER ${ALL_HEADERS})
    file(APPEND "${FULL_PATH}"
      "#include \"${HEADER}\"\n"
      )
  endforeach(HEADER)
endfunction(tl_autogen_single_include)

# -----------------------------------------------------------------------------

TLOC_LOG_LINE  (STATUS)

# -----------------------------------------------------------------------------
