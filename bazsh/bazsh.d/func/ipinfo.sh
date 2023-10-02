# Shorthand for ipinfo.io

ipinfo(){(
  local ARG="$1"

  _help(){
    cat <<EOF
ipinfo - Get IP info from ipinfo.io

USAGE

  ipinfo  [{{ipaddr}}]
  ipinfo  -h

Get the current host public IP address info when no argument is given.

OPTIONS

  -h  Show this help
EOF
  }

  case "$ARG" in
    -h) _print_help ;;
    * ) curl -s ipinfo.io/$ARG | jq ;;
  esac
)} # ipinfo

