# Pull all git repos under a directory

git-pull-all()(
  _git-pull-all(){
    local PARENT="$1"
    local GITDIR
    local MASTER
    local STATUS

    if [ -d "$PARENT" ] ; then
      for g in "$PARENT"/*/.git ; do

        GITDIR="$(dirname $g)"

        printf '\n\e[36m%s\e[0m\n' "$GITDIR" # cyan colored
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

    else
      echo "$PARENT is not a directory"
      return 1

    fi
  } # _git-pull-all

  usage(){
    cat <<EOF
git-pull-all - Pull all git repos under a directory

USAGE

  git-pull-all DIR
  git-pull-all [OPTION]

  OPTION

    -h
    --help
      Show this help
EOF
  } # usage

  case "$1" in
    -h|--help)
      usage
    ;;

    *)
      _git-pull-all "$@"
    ;;
  esac
) # git-pull-all

alias gitpullall="git-pull-all"
alias   gpullall="git-pull-all"
alias      gpall="git-pull-all"
alias        gpa="git-pull-all"

