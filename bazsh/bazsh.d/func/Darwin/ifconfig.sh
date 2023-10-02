# macOS - Better ifconfig

ifconfig()(
  # CIDR netmask
  ifconfigc(){
    local IFCONFIG="$( command ifconfig $@ )"
    local NETMASK

    get_netmasks \
    | while read xNETMASK ; do
        NETMASK="$(
          {
            echo 'obase=2'
            echo 'ibase=16'
            echo $xNETMASK \
            | tr '[a-z]' '[A-Z]'
          } \
          | bc \
          | tr -d '0\n' \
          | wc -c \
          | tr -d ' '
        )"

        IFCONFIG="$(
          echo "$IFCONFIG" \
          | sed 's, netmask 0x'$xNETMASK',/'$NETMASK','
        )"
      done

    echo "$IFCONFIG" \
    | sed 's,^[^[:space:]],\n&,'
  } # ifconfigc

  # Decimal netmask
  ifconfigd(){
    local IFCONFIG="$( command ifconfig $@ )"
    local NETMASK

    get_netmasks \
    | while read xNETMASK ; do
        NETMASK="$(
          {
            # obase must be defined before ibase
            # to prevent weird results.
            echo 'obase=10'
            echo 'ibase=16'
            echo $xNETMASK \
            | sed -r 's,[[:xdigit:]]{2},&\;,g' \
            | tr '[a-z]' '[A-Z]'
          } \
          | bc \
          | tr '\n' '.' \
          | sed 's,\.$,,'
        )"

        IFCONFIG="$(
          echo "$IFCONFIG" \
          | sed -r 's,( netmask )0x'$xNETMASK',\1'$NETMASK','
        )"
      done

    echo "$IFCONFIG" \
    | sed 's,^[^[:space:]],\n&,'
  } # ifconfigd

  ifconfigx(){
    command ifconfig "$@" \
    | sed 's,^[^[:space:]],\n&,'
  } # ifconfigx

  get_netmasks(){
    echo "$IFCONFIG" \
    | sed -nr \
        's,.*netmask 0x([[:xdigit:]]{8}).*,\1,p'
  } #get_netmasks

  colorize(){
    printf '%b\n' "$(
      eval "$@" \
      | sed -r \
          \
          `# interface name or bridge member interface` \
          -e 's,^([[:space:]]+member: )?([^[:space:]:]+)(:?),\1\\e[1m\2\\e[m\3,' \
          \
          `# MAC address` \
          -e 's,(ether )([[:xdigit:]:]+),\1\\e[1;2;33m\2\\e[m,' \
          \
          `# status active` \
          -e 's,(status: )(active),\1\\e[1;32m\2\\e[m,' \
          \
          `# status inactive` \
          -e 's,(status: )(inactive),\1\\e[1;31m\2\\e[m,' \
          \
          `# netmask; must be processed before IPv4` \
          -e 's,((netmask|prefixlen|inet [[:digit:]\.]+)[ \/])([[:xdigit:]x\.]+),\1\\e[1;35m\3\\e[m,' \
          \
          `# IPv4` \
          -e 's,(inet )([[:digit:]\.]+),\1\\e[1;36m\2\\e[m,' \
          \
          `# IPv6` \
          -e 's,(inet6 )([[:xdigit:]:]+),\1\\e[1;34m\2\\e[m,' \
    )"
  } # colorize

  case "$1" in
    -c|--cidr)
      shift
      colorize ifconfigc "$@"
    ;;

    -d|--decimal)
      shift
      colorize ifconfigd "$@"
    ;;

    -x|--hexadecimal)
      shift
      colorize ifconfigx "$@"
    ;;

    *)
      colorize ifconfigc "$@"
    ;;
  esac
) #ifconfig

