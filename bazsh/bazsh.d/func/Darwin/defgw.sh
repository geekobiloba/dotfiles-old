# macOS - Pretty print default gateway

defgw(){(
  local OPT="$@"

  _help(){
    cat <<"EOF"
defgw - Pretty print default gateway

USAGE

  defgw  [-4|-6|-h]

OPTIONS

Print both IPv4 and IPv6 when no option is given.

  -4  IPv4 only

  -6  IPv6 only

  -h  Show this help
EOF
  } # _help

  _get_defgw(){
    netstat -nr $(
      echo "$OPT" |\
      sed \
        -e 's,-4,-f inet ,' \
        -e 's,-6,-f inet6,'
    ) \
    | awk '
        /^(Destination|default|0\/1)/ {
          if ($1 == "Destination" && head > 0)
            next # print only the second header
          else
            print
          head++
        }
      ' \
    | column -t
  } # _get_defgw

  _fmt_defgw(){
    _get_defgw |\
    sed -r '1s,^.+$,\\e[1;36m&\\e[m,'
  } # _fmt_defgw

  _print_defgw(){
    printf '%b\n' "$(_fmt_defgw)"
  } # _print_defgw

  # Main
  case "$OPT" in
    -4|-6|"") _print_defgw ;;
    -h      ) _print_help ;;
    *       )
      _print_help_err
      return 1
      ;;
  esac
)} # defgw

