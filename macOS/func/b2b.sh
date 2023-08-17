# Convert number between bases.

b2b(){
  {
    echo "obase=$2"
    echo "ibase=$1"
    echo "$3" \
    | tr 'a-z' 'A-Z' # bc only accepts uppercase hexadecimal digits
  } \
  | bc
}

bin2dec(){ b2b  2 10 $1 ;}
bin2hex(){ b2b  2 16 $1 ;}
dec2bin(){ b2b 10  2 $1 ;}
dec2hex(){ b2b 10 16 $1 ;}
hex2bin(){ b2b 16  2 $1 ;}
hex2dec(){ b2b 16 10 $1 ;}

