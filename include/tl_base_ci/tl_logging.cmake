# -----------------------------------------------------------------------------
# logging

# -----------------------------------------------------------------------------
# MODE: same as CMake message(<mode>)
function(TLOC_LOG MODE MSG)

  # ---------------------------------------------------------------------------
  # colors

  if(NOT WIN32)
    string(ASCII 27 Esc)
    set(ColourReset "${Esc}[m")
    set(ColourBold  "${Esc}[1m")
    set(Red         "${Esc}[31m")
    set(Green       "${Esc}[32m")
    set(Yellow      "${Esc}[33m")
    set(Blue        "${Esc}[34m")
    set(Magenta     "${Esc}[35m")
    set(Cyan        "${Esc}[36m")
    set(White       "${Esc}[37m")
    set(BoldRed     "${Esc}[1;31m")
    set(BoldGreen   "${Esc}[1;32m")
    set(BoldYellow  "${Esc}[1;33m")
    set(BoldBlue    "${Esc}[1;34m")
    set(BoldMagenta "${Esc}[1;35m")
    set(BoldCyan    "${Esc}[1;36m")
    set(BoldWhite   "${Esc}[1;37m")
  endif()


  if(${MODE} STREQUAL "STATUS")
    message(${MODE} "${BoldBlue}${MSG}${ColourReset}")
  elseif(${MODE} STREQUAL "SUCCESS")
    message(STATUS "${BoldGreen}${MSG}${ColourReset}")
  elseif(${MODE} STREQUAL "INFO")
    message(STATUS "${BoldWhite}${MSG}${ColourReset}")
  elseif(${MODE} STREQUAL "DEBUG")
    message(STATUS "${BoldCyan}${MSG}${ColourReset}")
  elseif(${MODE} STREQUAL "ATTENTION")
    message(STATUS "${BoldMagenta}${MSG}${ColourReset}")
  elseif(${MODE} STREQUAL "WARNING")
    message(${MODE} "${BoldYellow}${MSG}${ColourReset}")
  elseif(${MODE} STREQUAL "FATAL_ERROR" OR ${MODE} STREQUAL "SEND_ERROR")
    if (TLOC_IGNORE_FATAL_ERROR)
      set(MODE "WARNING")
    endif()
    message(${MODE} "${BoldRed}${MSG}${ColourReset}")
  elseif(${MODE} STREQUAL "DEPRECATION")
    message(${MODE} "${Yellow}${MSG}${ColourReset}")
  else()
    message(${MODE} ${MSG})
  endif()
endfunction()

# -----------------------------------------------------------------------------
# Logs with TLOC_LOG_DETAIL will not appear by default
# MODE: same as CMake message(<mode>)
function(TLOC_LOG_DETAIL MODE MSG)
  if (TLOC_DETAILED_LOGS)
    TLOC_LOG(${MODE} "${MSG}")
  endif()
endfunction()

# -----------------------------------------------------------------------------
function(TLOC_LOG_LINE MODE)
  TLOC_LOG_DETAIL(${MODE} "----------------------------------------------------------")
endfunction()

# -----------------------------------------------------------------------------
function(TLOC_LOG_NEWLINE MODE)
  TLOC_LOG_DETAIL(${MODE} " ")
endfunction()

# -----------------------------------------------------------------------------
function(TLOC_LOG_DETAIL_VAR MODE _VAR)
  TLOC_LOG_DETAIL(${MODE} "${_VAR}: ${${_VAR}}")
endfunction()

# -----------------------------------------------------------------------------
function(TLOC_LOG_VAR MODE _VAR)
  TLOC_LOG(${MODE} "${_VAR}: ${${_VAR}}")
endfunction()
