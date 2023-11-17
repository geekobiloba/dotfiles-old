gcalcli(){
  case "$1" in
    calw|calm)
      command gcalcli $1 --monday "${@:2:$#}"
      ;;
    *)
      command gcalcli "$@"
      ;;
  esac
}

