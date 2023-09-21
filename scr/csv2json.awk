#!/usr/bin/env awk -f
#
# Convert CSV to JSON using GNU Awk
#
# On macOS, install gawk,
#
#   brew install gawk
#
# then put the following into your ~/.zshrc
#
#   export PATH="$HOMEBREW_PREFIX/opt/gawk/libexec/gnubin:$PATH"
#
# To use another CSV delimiter, like semicolon,
# export it into CSV_DELIMITER environment variables,
# or set it locally as follows,
#
#   CSV_DELIMITER=';' ./csv2json.awk file.csv
#

# Normalize double quotes
function ndq(str){
  gsub("^|$", "\"", str) # enclose str with double quotes
  gsub("\"+", "\"", str) # squeeze multiple double quotes

  return str
}

BEGIN {
  # Get FS from environment; default to comma
  FS = ENVIRON["CSV_DELIMITER"] ? ENVIRON["CSV_DELIMITER"] : ","

  FS = "[[:space:]]*" FS "[[:space:]]*" # Normalized FS
  _  = "  "                             # Indentation spaces
}

# Collect keys from CSV header, that is line 1
NR == 1 {

  # Output Number-of-Field
  # Need primarily by END section, which cannot use NF
  # Used in each line for consistency
  ONF=NF

  for (i=1;i<=ONF;i++) key[i] = ndq($i)
}

# Collect values from line 2 to the rest of lines
NR >= 2 {
  for (i=1;i<=ONF;i++) val[i][NR] = ndq($i)
}

END {
  print "["

  for (i=2;i<NR;i++){
    print _ "{"

    for (j=1;j<=ONF;j++){
      if (j < ONF) print _ _ key[j] ": " val[j][i] ","
      else         print _ _ key[j] ": " val[j][i]
    }

    if (i < NR-1) print _ "},"
    else          print _ "}"
  }

  print "]"
}

