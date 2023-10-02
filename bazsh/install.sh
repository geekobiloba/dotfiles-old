#!/usr/bin/env sh

DIR="$(dirname "$0")"

case "$(uname -s)" in
  Linux)
    ETC=/etc
    ;;
  FreeBSD)
    ETC=/usr/local/etc
    ;;
  Darwin)
    ETC=/etc
    ;;
  SunOS)
    ETC=/etc
    ;;
esac

rm -f "$HOME"/.bazshrc
cp     "$DIR"/.bazshrc $HOME

# root
if [ $UID -eq 0 ] ; then
  rm -f $HOME/.bazsh.d
  rm -f $ETC/bazshrc

  find $ETC/bazsh.d -type f -not -name custom.sh -delete 2>/dev/null
  find $ETC/bazsh.d -type d -empty -delete               2>/dev/null

  cp -r "$DIR"/bazshrc "$DIR"/bazsh.d $ETC
else
  find $HOME/.bazsh.d -type f -not -name custom.sh -delete 2>/dev/null
  find $HOME/.bazsh.d -type d -empty -delete               2>/dev/null

  cp -r "$DIR"/.bazsh.d $HOME

  printf '%b\n' '
Now run \e[1minstall.sh\e[m as root.  If using sudo, make sure you login
as root before running it,\e[1m

  $ sudo su
  # ./install.sh
\e[m'
fi

printf '%b\n' '
Make sure you add the following line into your \e[1m~/.bashrc\e[m or
\e[1m~/.zshrc\e[m file:\e[1m

  test -f ~/.bazshrc && . $_
\e[m'

