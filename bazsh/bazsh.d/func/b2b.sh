# Convert number between bases

b2b(){(
  local   OPT=$1
  local IBASE=$1
  local OBASE=$2
  local   NUM=$3

  _help(){
    cat <<EOF
b2b - Convert number between bases

USAGE

  b2b  {{ibase}} {{obase}} {{num}}

  b2b  -h

OPTIONS

  {{ibase}}  Input base, integer > 1

  {{obase}}  Output base, integer > 1

  {{num}}    Number to convert

  -h     Show this help
EOF
  } # _help

  _b2b(){
    {
      # Define obase before ibase to prevent quirks!
      echo "obase=$OBASE"
      echo "ibase=$IBASE"

      # bc only accepts uppercase hex digits
      echo "$NUM" | tr 'a-z' 'A-Z'
    } \
    | bc
  } # _b2b

  # Main
  case "$OPT" in
    -h) _print_help ;;
    * )
      if # check if each bases is an integer > 1, and if $NUM is number
        echo $IBASE | grep -Eq '^-?([[:digit:]]+)?\.?[[:digit:]]+$' && \
        echo $OBASE | grep -Eq '^-?([[:digit:]]+)?\.?[[:digit:]]+$' && \
        [ $IBASE -gt 1 ] && \
        [ $OBASE -gt 1 ] && \
        echo $NUM   | grep -Eq '^-?([[:xdigit:]]+)?\.?[[:xdigit:]]+$'
      then
        _b2b $IBASE $OBASE $NUM
      else
        _print_help_err
        return 1
      fi
      ;;
  esac
)} # b2b

alias bin2oct="b2b  2  8"
alias bin2dec="b2b  2 10"
alias bin2hex="b2b  2 16"
alias oct2bin="b2b  8  2"
alias oct2dec="b2b  8 10"
alias oct2hex="b2b  8 16"
alias dec2bin="b2b 10  2"
alias dec2oct="b2b 10  8"
alias dec2hex="b2b 10 16"
alias hex2bin="b2b 16  2"
alias hex2oct="b2b 16  8"
alias hex2dec="b2b 16 10"

