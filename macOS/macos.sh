cd "$( dirname "$0" )"

. ./alias.sh

for i in func/*.sh  ; do . $i ; done

cd - 1>/dev/null

