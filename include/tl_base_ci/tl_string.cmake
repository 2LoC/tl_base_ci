# -----------------------------------------------------------------------------
# string compare lower case

function(TLOC_STREQUAL_LOWERCASE STRING_A STRING_B IS_EQUAL)
  string(TOLOWER "${STRING_A}" stringA)
  string(TOLOWER "${STRING_B}" stringB)
  if (${stringA} STREQUAL ${stringB})
    set(${IS_EQUAL} TRUE PARENT_SCOPE)
  else()
    set(${IS_EQUAL} FALSE PARENT_SCOPE)
  endif()
endfunction()
