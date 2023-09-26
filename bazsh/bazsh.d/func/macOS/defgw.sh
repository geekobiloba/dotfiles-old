# macOS - Pretty print default gateway

defgw()(
  local OPTS="$@"

  print_usage(){
    cat <<"EOF"
defgw - Pretty print default gateway

USAGE

  defgw [OPTSION]

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

  get_defgw(){
    netstat -nr $(
      echo "$@" |\
      sed \
        -e 's,-4,-f inet ,' \
        -e 's,-6,-f inet6,'
    ) \
    | awk '
        /^(Destination|default|0\/1)/ {

          # Print only the second header
          if ($1 == "Destination" && header > 0) next
          else                                   print

          header++
        }
      ' \
    | column -t
  } # get_defgw

  colorize_defgw(){
    get_defgw "$@" |\
    sed -r '1s,^.+$,\\e[1;36m&\\e[m,'
  } # colorize_defgw

  print_defgw(){
    printf '%b\n' "$(colorize_defgw)"
  } # print_defgw

  case "$OPTS" in
    -h|--help)
      print_usage
      ;;

    -4|-6|"")
      print_defgw "$OPTS"
      ;;

    *)
      print_usage
      exit 1
      ;;
  esac
) #defgw

