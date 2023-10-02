# Bring back `pip search``

function pip(){
  if [ "$1" = "search" ]; then
    pip_search "$2"
  else
    command pip "$@"
  fi
}

