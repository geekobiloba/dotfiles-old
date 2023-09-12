# macOS - Pretty print default gateway

defgw()(
  _defgw(){
    netstat -nr $(
      echo "$@" \
      | sed \
          -e 's,-4,-f inet ,' \
          -e 's,-6,-f inet6,'
    ) \
    | awk '
        /^(Destination|default|0\/1)/ {
          # Skip the second header
          if ( $1 == "Destination" && header != 0 ) {
            next
          } else {
            print
            ++ header
          }
        }
      ' \
    | column -t \
  } # _defgw

  usage(){
    cat <<EOF
defgw - Pretty print default gateway

USAGE

  defgw [OPTION]

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
  } # usage

  colorize(){
    printf '%b\n' "$(
      eval "$@" \
      | sed -r \
        -e '1s,^.+$,\\e[1;36m&\\e[m,'
    )"
  } # colorize

  error_1(){
    echo "Unrecognized option: $@"
    return 1
  } # error_1

  case "$1" in
    -h|--help)
      usage
    ;;

    -4|-6|"")
      colorize _defgw "$@"
    ;;

    *)
      error_1 "$@"
    ;;
  esac
) #defgw

