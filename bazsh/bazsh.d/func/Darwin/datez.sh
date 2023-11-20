# Convert time and date between two timezones

datez(){(
  local TZ_FROM="$1"
  local TZ_DEST="$2"
  local    TIME="$3"
  local   _DATE="$(date +%F)"
  local    DATE="${4:=$_DATE}"

  help(){
    cat <<EOF
USAGE

  tzdate TZ_FROM TZ_DEST HH:MM[:SS] [ YYYY-MM-DD ]

EOF
  }

  if   [ -n "$TZ_FROM" ] \
    && [ -n "$TZ_FROM" ] \
    && [ -n "$TIME"    ] ; then

    TZ="$TZ_DEST" \
    date -r $(
      TZ="$TZ_FROM" \
      date -jf '%F %R' "$DATE $TIME" +%s
    )
  else
    help
    return 1
  fi
)}

