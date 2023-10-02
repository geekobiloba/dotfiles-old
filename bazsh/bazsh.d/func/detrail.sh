# Remove trailing spaces from a file

detrail(){(
  local ARG="$1"

  _help(){
    cat <<EOF
detrail - Remove trailing spaces from a file

USAGE

  detrail  {{file}}
  detrail  -h

OPTIONS

  -h  Show this help
EOF
  }

  case "$ARG" in
    -h) _print_help ;;
    * )
      if [ -f "$ARG" ] ; then
        sed -ri "" 's,[[:space:]]+$,,g' "$ARG"
      else
        _print_help_err
        return 1
      fi
      ;;
  esac
)}

