# macOS - Sort mas search and list results by app name

mas(){
  case "$1" in
    (search|list)
      command mas "$@" |\
      sort -fk2 # sort ignore-case by field 2
      ;;
    (*)
      command mas "$@"
      ;;
  esac
}

