# Sort mas search and list by app name

mas(){
  case "$1" in
    search|list)
      command mas "$@" \
      | sort -fk2 # sort ignoring case by field 2
    ;;
    *)
      command mas "$@"
    ;;
  esac
}

