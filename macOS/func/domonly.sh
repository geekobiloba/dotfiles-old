# Print the first found domain name from a string.

domonly(){
  echo $1 \
  | grep -Eio '([[:alnum:]]+[[:alnum:]-]+\.[[:alnum:]]+)+' \
  | head -n 1
}

