# Search for pip packages with pip search anything

function pip()(
  if [ $1 = "search" ]; then
    pip_search "$2"
  else
    command pip "$@"
  fi;
)

alias pip3='pip'

