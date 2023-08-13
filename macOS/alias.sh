# vim: filetype=bash

alias   pbcopy="pbcopy -pboard general -Prefer txt"
alias  ppbcopy="tr -d '\n' | pbcopy"
alias    xclip="pbcopy"
alias   xxclip="ppbcopy"
alias     catb='bat'
alias     catl='lolcat'
alias cpufetch="cpufetch | lolcat -f"
alias     rdig="dig -x"
alias    iperf="iperf3"
#alias    iperf="iperf3-darwin"

# browsers
alias ffp="firefox -p 2>/dev/null"
alias w3m="w3m -sixel -H -F"
#alias w4m='w3m -T text/html'

# subjects to change
alias highlight="highlight -s candy"
alias      cath="highlight"
#alias linguist="github-linguist"

alias neofetch='naughtyfetch ~/Private/asciiart/img/karen-kaede-9.jpg 78 "0OQ"'
#alias neofetch='naughtyfetch ~/Private/asciiart/img/karen-kaede-31sq.png 56 "QO0MWAV"'

alias gpl='gh profile list'

# k8s
alias krew='kubectl krew'
alias kctx='kubectl ctx'
alias  kns='kubectl ns'
