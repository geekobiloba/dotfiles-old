# Shorthand for ipinfo.io

asninfo(){(
  local ASN
  local SHORTJSON=0

  _help(){
    cat <<EOF
ipinfo - Get ASN info from peeringdb.com as JSON

USAGE

  asninfo  [-s] {{asn}}
  asninfo  -h

OPTIONS

  {{asn}}  AS number.
       Format can be number only, or AS{{number}} (case-insensitive).

  -s   Output short JSON array,
       only ASN, name, website, update, and status.
       
  -h   Show this help
EOF
  } # _help

  _get_asninfo(){
    local ASN=$1

    curl \
      -s \
      -H "Authorization: Api-Key $PEERINGDBDOTCOM_KEY" \
      -H "Content-Type: application/json" \
      -X GET \
      "https://www.peeringdb.com/api/net?asn=$ASN" \
    | jq
  } # _get_asninfo

  while getopts :sh o ; do
    case "$o" in
      s) SHORTJSON=1 ;;
      h)
        _print_help
        exit
        ;;
      *)
        _print_help_err
        exit 1
        ;;
    esac
  done
  shift $((OPTIND-1))

  # Main
  ASN="$(
    echo $1 \
    | grep -Eio '^(AS)?[[:digit:]]+$' \
    | grep -Eo  '[[:digit:]]+'
  )"

  if [ -n "$ASN" ] ; then
    if [ $SHORTJSON -eq 1 ] ; then
      _get_asninfo $ASN |\
      jq '[ .data[0] | .asn, .name, .website, .updated, .status ]'
    else
      _get_asninfo $ASN
    fi
  else
    _print_help_err
    return 1
  fi
)} # ipinfo

alias asinfo="asninfo -s"

