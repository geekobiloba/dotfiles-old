# vim: set filetype=bash

domonly(){
  echo "$1" \
  | ggrep -Eio '([a-z0-9][a-z0-9-]+\.[a-z0-9]+)+' \
  | head -n 1
}

