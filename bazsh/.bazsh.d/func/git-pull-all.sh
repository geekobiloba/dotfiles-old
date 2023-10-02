# Pull all git repos under a directory

git-pull-all(){(
  local ARG="$1"

  _help(){
    cat <<EOF
git-pull-all - Pull all git repos under a directory

USAGE

  git-pull-all {{dir}}

  git-pull-all -h

OPTIONS

  -h  Show this help
EOF
  } # _help

  _git-pull-all(){
    local PARENT="$1"
    local GITDIR
    local MASTER
    local STATUS

    for g in "$PARENT"/*/.git ; do
      GITDIR="$(dirname $g)"

      printf '\n\e[36m%s\e[0m\n' "$GITDIR" # cyan
      cd "$GITDIR"

      MASTER="$(
        git branch -r \
        | sed -nr 's,.+-> origin/([^[:space:]]+),\1,p'
      )"

      (
        set -x # xtrace only git commands
        git checkout $MASTER \
        && git pull
      )

      STATUS=$?

      cd - 1>/dev/null

      if [ $STATUS -ne 0 ] ; then
        printf '\n\e[1;31m%s\e[0m' 'ERROR: '
        echo "Last git command exit code: $STATUS"
        return 1
      fi

    done
  } # _git-pull-all

  # Main
  case "$ARG" in
    (-h) _print_help ;;
    (* )
      if [ -d "$ARG" ] ; then
        _git-pull-all "$ARG"
      else
        echo "No such directory: $ARG"
        return 1
      fi
      ;;
    ("")
      _print_help_err
      return 1
      ;;
  esac
)} # git-pull-all

alias gitpullall="git-pull-all"
alias   gpullall="git-pull-all"
alias      gpall="git-pull-all"
alias        gpa="git-pull-all"

