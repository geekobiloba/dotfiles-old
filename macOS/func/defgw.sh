# vim: set filetype=bash

defgw(){
  local ARGV

  case "$1" in
    -4)
      ARGV='-f inet'
    ;;
    -6)
      ARGV='-f inet6'
    ;;
    "")
    ;;
    *)
      echo "Unrecognized option: $@"
      return 1
    ;;
  esac

  netstat -nr $( echo "$ARGV" ) \
  | awk '
      /^(default|Destination)/ {
        if ( $1 == "Destination" && header != 0 ) {
          next
        } else {
          print
          header+=1
        }
      }
    ' \
  | column -t
}

