# Convert number between bases

b2b(){(
  local   OPT="$1"
  local IBASE="$1"
  local OBASE="$2"
  local   NUM="$3"

  usage(){
    cat <<EOF
b2b - Convert number between bases

USAGE

  b2b {{ibase}} {{obase}} {{num}}

  b2b -h

ARGUMENTS

  {{ibase}}  Input base

  {{obase}}  Output base

  {{num}}    Number to convert

  -h     Show this help
EOF
  } # usage

  _b2b(){
    {
      echo "obase=$OBASE" # define obase before ibase to prevent quirks
      echo "ibase=$IBASE"
      echo "$NUM" \
      | tr 'a-z' 'A-Z' # only uppercase hexadecimal digits are accepted
    } \
    | bc
  } # _b2b

  case "$OPT" in
    -h)
      print_usage
      ;;

    *)

      # Check if all arguments are integers
      if 
        echo $IBASE | grep -E '^[[:digit:]]+$' &>/dev/null && \
        echo $OBASE | grep -E '^[[:digit:]]+$' &>/dev/null && \
        echo $NUM   | grep -E '^[[:digit:]]+$' &>/dev/null
      then
         _b2b $IBASE $OBASE $NUM
      else
         print_usage
         return 1
      fi
      ;;
  esac
)}

alias bin2dec="b2b  2 10"
alias bin2hex="b2b  2 16"
alias dec2bin="b2b 10  2"
alias dec2hex="b2b 10 16"
alias hex2bin="b2b 16  2"
alias hex2dec="b2b 16 10"

