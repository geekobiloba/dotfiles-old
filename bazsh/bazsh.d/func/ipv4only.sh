# Print the first found IPv4 from a string

ipv4only(){
  echo $1 \
  | grep -Eo \
      '((25[012345]|2[01234][[:digit:]]|1?[[:digit:]]?[[:digit:]])\.){3}(25[012345]|2[01234][[:digit:]]|1?[[:digit:]]?[[:digit:]])' \
  | head -n1
}

alias iponly='ipv4only'

