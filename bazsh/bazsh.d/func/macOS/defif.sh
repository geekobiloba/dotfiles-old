# macOS - Print default network interfaces

defif()(
  local OPT="$1"

  print_defif(){
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

  print_usage(){
    cat <<EOF
defif - Print default network interfaces info

USAGE

  defif [OPTION]

  Print both IPv4 and IPv6 when no option is given.

  OPTION

    -h
    --help
      Show this help

    -4
      IPv4 only

    -6
      IPv6 only
EOF
  } # print_usage

  case "$OPT" in
    -4|-6|"")
      print_defif
      ;;

    -h|--help)
      print_usage
      ;;

    *)
      print_usage
      return 1
      ;;
  esac
) # defif

