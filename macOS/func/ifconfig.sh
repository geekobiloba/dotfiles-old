# vim: set filetype=bash

ifconfig()(
  ifconfigc(){
    local IFCONFIG="$( command ifconfig $@ )"
    local NETMASKS="$( netmasks )"

    while read n ; do
      IFCONFIG="$(
        local o="$(
          {
            echo 'obase=2'
            echo 'ibase=16'
            echo $n \
            | tr '[a-z]' '[A-Z]'
          } \
          | bc \
          | tr -d '0\n' \
          | wc -c \
          | tr -d ' '
        )"

        echo "$IFCONFIG" \
        | gsed 's, netmask 0x'$n',/'$o',' 
      )"
    done <<EOF
$( echo "$NETMASKS" )
EOF

    echo "$IFCONFIG"
  }

  ifconfigd(){
    local IFCONFIG="$( command ifconfig $@ )"
    local NETMASKS="$( netmasks )"

    while read n ; do
      IFCONFIG="$(
        local o="$(
          {
            echo 'obase=10' # obase must be defined before ibase to prevent weird results.
            echo 'ibase=16'
            echo $n \
            | tr '[a-z]' '[A-Z]' \
            | gsed -r 's,[0-9A-F]{2},&\;,g'
          } \
          | bc \
          | tr '\n' '.' \
          | gsed 's,\.$,,'
        )"

        echo "$IFCONFIG" \
        | gsed -r 's,( netmask )0x'$n',\1'$o',' 
      )"
    done <<EOF
$( echo "$NETMASKS" )
EOF

    echo "$IFCONFIG"
  }

  netmasks(){
    echo "$IFCONFIG" \
    | gsed -nr \
        's,.*netmask 0x([0-9a-f]{8}).*,\1,p'
  }

  case "$1" in
    -c|--cidr)
      shift
      ifconfigc $@
    ;;
    -d|--decimal)
      shift
      ifconfigd $@
    ;;
    -x|--hexadecimal|-r|--real)
      shift
      command ifconfig $@
    ;;
    *)
      ifconfigc $@
    ;;
  esac
)
