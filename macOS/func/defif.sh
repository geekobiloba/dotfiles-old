# Print default network interfaces info on macOS

defif()(
  _defif(){
    local IPTYPE="$(
      echo  "$@" \
      | sed \
          -e 's,-4,inet,' \
          -e 's,-6,inet6,'
    )"

    for IF in $( defgw "$@" | awk 'NR != 1 {print $4}' ) ; do
      ifconfig $IF $IPTYPE
    done
  }

  usage(){
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
  }

  case "$1" in
    -4|-6|"")
      _defif "$@"
    ;;

    -h|--help)
      usage
    ;;

    *)
      echo "Unrecognized option: $@"
      return 1
    ;;
  esac
)

