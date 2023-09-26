# Convert number between bases

b2b(){
  local IBASE="$1"
  local OBASE="$2"
  local INPUT="$3"

  {
    echo "obase=$OBASE" # define obase before ibase to prevent quirks
    echo "ibase=$IBASE"
    echo "$INPUT" \
    | tr 'a-z' 'A-Z' # only uppercase hexadecimal digits are accepted
  } \
  | bc
}

alias bin2dec="b2b  2 10"
alias bin2hex="b2b  2 16"
alias dec2bin="b2b 10  2"
alias dec2hex="b2b 10 16"
alias hex2bin="b2b 16  2"
alias hex2dec="b2b 16 10"

