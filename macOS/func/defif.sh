defif(){
  local ARGV

  case "$1" in
    -4)
      ARGV='-4'
    ;;
    -6)
      ARGV='-6'
    ;;
    "")
    ;;
    *)
      echo "Unrecognized option: $@"
      return 1
    ;;
  esac

  for i in $( defgw "$ARGV" | awk 'NR!=1 {print $4}' ) ; do
    ifconfig $i
  done
}

