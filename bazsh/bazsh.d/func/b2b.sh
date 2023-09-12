# Convert number between bases

b2b(){
  {
    echo "obase=$2"
    echo "ibase=$1"
    echo "$3" \
    | tr 'a-z' 'A-Z' # bc only accepts uppercase hexadecimal digits
  } \
  | bc
}

alias bin2dec="b2b  2 10"
alias bin2hex="b2b  2 16"
alias dec2bin="b2b 10  2"
alias dec2hex="b2b 10 16"
alias hex2bin="b2b 16  2"
alias hex2dec="b2b 16 10"

