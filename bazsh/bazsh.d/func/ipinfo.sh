# Shorthand for ipinfo.io

ipinfo(){
  local IP=$1

  if [ -n $IP ]; then
    curl -s ipinfo.io/$IP | jq
  else
    curl -s ipinfo.io     | jq
  fi
}

