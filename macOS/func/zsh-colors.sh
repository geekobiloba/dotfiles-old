# vim: set filetype=bash

 # ZSH only
if echo $SHELL | grep -w zsh &>/dev/null ; then
  zsh-colors(){
    for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
  }
fi
