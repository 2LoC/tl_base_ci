# -----------------------------------------------------------------------------

include_guard()

# -----------------------------------------------------------------------------
# emulating maps

MACRO(INSERT_INTO_MAP _NAME _KEY _VALUE)
  SET("${_NAME}_${_KEY}" "${_VALUE}")
ENDMACRO(INSERT_INTO_MAP)
