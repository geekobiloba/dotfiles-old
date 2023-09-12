# Shorthands for highlight and bat

highlight(){
  case $1 in
    -*)
      command highlight "$@"
    ;;

    *)
      if [ -n "$2" ] ; then
        command highlight -S $2 "$1"
      else
        command highlight "$@"
      fi
    ;;
  esac
}

bat(){
  case $1 in
    -*)
      command bat "$@"
    ;;

    *)
      if [ -n "$2" ] ; then
        command bat -l $2 "$1"
      else
        command bat "$@"
      fi
    ;;
  esac
}

alias hcat="highlight"
alias cath="hcat"
alias bcat="catb"

