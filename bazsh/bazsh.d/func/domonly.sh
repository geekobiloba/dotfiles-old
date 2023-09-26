# Print the first found domain name from a string

domonly(){
  local STR="$1"

  echo "$STR" \
  | grep -Eio \
      '([[:alnum:]]+[[:alnum:]-]+\.[[:alnum:]]+)+' \
  | head -n1
}

