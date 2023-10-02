# Print the first found IPv4, IPv6, or domain name in a string

ipdomonly(){(
  local OPT="$1"
  local STR="$2"

  _help(){
    cat <<EOF
ipdomonly - Print the first found IPv4, IPv6, or domain name in a string

USAGE

  ipdomonly  (-4|-6|-d) {{string}}

  ipdomonly  -h

OPTIONS

  -4  IPv4 only

  -6  IPv6 only

  -d  Domain name only

  -h  Show this help
EOF
  } # _help

  # Print the first found IPv4 in a string
  _ip4only(){
    local STR="$1"

    echo "$STR" \
    | grep -Eo  \
        '((25[012345]|2[01234][[:digit:]]|1?[[:digit:]]?[[:digit:]])\.){3}(25[012345]|2[01234][[:digit:]]|1?[[:digit:]]?[[:digit:]])' \
    | head -n1
  } # _ip4only

  # Print the first found IPv6 in a string
  # See <https://stackoverflow.com/questions/53497/regular-expression-that-matches-valid-ipv6-addresses>
  _ip6only(){
    local STR="$1"

    echo "$STR" \
    | grep -Eo  \
        '(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))' \
    | head -n1
  } # _ip6only

  # Get the first found domain name in a string
  _domonly(){
    local STR="$1"

    echo "$STR" \
    | grep -Eio \
        '[[:alnum:]]+([[:alnum:]-]*[[:alnum:]]+)*(\.|(\.[[:alnum:]]+([[:alnum:]-]*[[:alnum:]]+)*)+\.?)' \
    | head -n1
  } # _domonly

  # Main
  case "$OPT" in
    -4|-6|-d)
      if [ -n "$STR" ] ; then
        case "$OPT" in
          -4) _ip4only "$STR" ;;
          -6) _ip6only "$STR" ;;
          -d) _domonly "$STR" ;;
        esac
      else
        _print_help_err
        return 1
      fi
      ;;
    -h) _print_help ;;
    * )
      _print_help_err
      return 1
      ;;
  esac
)} # ipdomonly

alias ip4only="ipdomonly -4"
alias ip6only="ipdomonly -6"
alias domonly="ipdomonly -d"

