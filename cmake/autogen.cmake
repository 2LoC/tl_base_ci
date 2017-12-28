# -----------------------------------------------------------------------------
# Autogenerate all inclusive header

function(tl_autogen_all_inclusive_header HEADER_NAME HEADER_PATH GLOB_DIR)
  set(FULL_PATH "${HEADER_NAME}/${HEADER_PATH}")
  file(REMOVE "${FULL_PATH}")
  file(GLOB_RECURSE ALL_HEADERS RELATIVE "${HEADER_PATH}" *.h)

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
endfunction(tl_autogen_all_inclusive_header)
