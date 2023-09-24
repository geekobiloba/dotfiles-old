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

BEGIN {
  # Get FS from environment; default to comma
  FS = ENVIRON["CSV_DELIMITER"] ? ENVIRON["CSV_DELIMITER"] : ","

  FS      = "[[:space:]]*" FS "[[:space:]]*" # Normalized FS
  _       = "  " # Indentation spaces
  ONR     = 0    # Output number of records
  ONF     = 0    # Output number of fields
  IS_HEAD = 1    # Header flag for the first non-empty record
}

# Normalize double quotes
function ndq(str){

  # non-empty field
  if (str !~ /^["']?[[:space:]]*["']?$/){
    gsub("\"" , ""  , str) # remove all double quotes
    gsub("^|$", "\"", str) # enclose str with double quotes

    return str
  }

  # empty field
  else return "null"
}

# Skip every empty record
$0 ~ /^[[:space:]]*$/ { next }

# Collect keys from the first non-empty record
IS_HEAD {

  # ONF is needed by the END section, which cannot use NF
  ONF=NF

  for (i=1;i<=ONF;i++) key[i] = ndq($i)

  # Turn off header flag and move to the next record
  IS_HEAD = 0
  next
}

# Collect values for the second non-empty records and so on
! IS_HEAD {

  # Count non-empty records sequentially.
  # Using NR would be misleading here!
  ONR++

  for (i=1;i<=ONF;i++) val[i][ONR] = ndq($i)
}

END {
  print "["

  for (i=1;i<=ONR;i++){
    print _ "{"

    for (j=1;j<=ONF;j++){
      if (j < ONF) print _ _ key[j] ": " val[j][i] ","
      else         print _ _ key[j] ": " val[j][i]
    }

    if (i < ONR) print _ "},"
    else         print _ "}"
  }

  print "]"
}

