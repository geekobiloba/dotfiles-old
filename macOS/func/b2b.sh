# vim: set filetype=bash

b2b(){
#  echo ((16#${1}))

  {
    echo "obase=$2"
    echo "ibase=$1"
    echo "$3" \
    | tr 'a-z' 'A-Z'
  } \
  | bc
}

bin2dec(){
  b2b 2 10 $1
}

bin2hex(){
  b2b 2 16 $1
}

dec2bin(){
  b2b 10 2 $1
}

dec2hex(){
  b2b 10 16 $1
}

hex2bin(){
  b2b 16 2 $1
}

hex2dec(){
  b2b 16 10 $1
}

