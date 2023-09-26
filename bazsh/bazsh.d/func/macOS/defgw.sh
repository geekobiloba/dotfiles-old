# macOS - Pretty print default gateway

defgw()(
  local OPT="$@"

  usage(){
    cat <<"EOF"
defgw - Pretty print default gateway

USAGE

  defgw [OPTION]

Print both IPv4 and IPv6 when no option is given.

OPTION

  -4  IPv4 only

  -6  IPv6 only

  -h  Show this help
EOF
  } # usage

  get_defgw(){
    netstat -nr $(
      echo "$OPT" |\
      sed \
        -e 's,-4,-f inet ,' \
        -e 's,-6,-f inet6,'
    ) \
    | awk '
        /^(Destination|default|0\/1)/ {

          # Print only the second header
          if ($1 == "Destination" && header > 0)
            next
          else
            print
          header++
        }
      ' \
    | column -t
  } # get_defgw

  colorize_defgw(){
    get_defgw |\
    sed -r '1s,^.+$,\\e[1;36m&\\e[m,'
  } # colorize_defgw

  print_defgw(){
    printf '%b\n' "$(colorize_defgw)"
  } # print_defgw

  case "$OPT" in
    -4|-6|"")
      print_defgw
      ;;

    -h)
      print_usage
      ;;

    *)
      print_usage
      return 1
      ;;
  esac
) #defgw

