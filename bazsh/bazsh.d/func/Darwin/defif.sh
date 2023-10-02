# macOS - Print default network interfaces

defif(){(
  local OPT="$1"

  _help(){
    cat <<EOF
defif - Print default network interfaces info

USAGE

defif  [-4|-6|-h]

OPTIONS

Print both IPv4 and IPv6 when no option is given.

  -4  IPv4 only

  -6  IPv6 only

  -h  Show this help
EOF
  } # _help

  _defif(){
    local IPTYPE="$(
      echo  "$OPT" \
      | sed \
          -e 's,-4,inet,' \
          -e 's,-6,inet6,'
    )"

    for IFACE in $(defgw "$OPT" | awk 'NR>1 {print $4}') ; do
      ifconfig "$IFACE" "$IPTYPE"
    done
  } # _defif

  case "$OPT" in
    (-4|-6|"") _defif      ;;
    (-h      ) _print_help ;;
    (*       )
      _print_help_err
      return 1
      ;;
  esac
)} # defif

