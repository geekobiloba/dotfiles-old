# Standard UNIX tools
alias   rm="rm -i"
alias   mv="mv -i"
alias   cp="cp -i"
alias  cls="clear"
alias grep="grep -E --color"
alias  sed="sed -r"
alias   rl="readlink -f"
alias   bc="bc -l"

# Reload shell
alias reload="exec $SHELL"

# ls
alias    la="ls -a"
alias    ll="ls -l"
alias   lla="ls -la"
alias  llah="ls -lah"
alias   ls1="ls -1"

# xargs
alias  xargs="xargs "
alias xargsi="xargs -I '{}'"

# sudo
alias   sudo="sudo "
alias unsudo="sudo -k"

# iperf
alias iperf="iperf3"

# highlight
alias highlight="highlight -s candy"
alias      cath="highlight"
alias      hcat="cath"

# bat
alias batp="bat -P"
alias pbat="batp"
alias catb="batp"
alias bcat="batp"

# lolcat
alias catl="lolcat"
alias lcat="catl"

# exa
alias    l="exa -lgh"
alias   lx="exa"
alias  lxa="l -a"
alias  lxt="l -T"
alias lxta="lxt -a"
alias lxat="lxta"
alias  lx1="lx -1"

# ripgrep
alias    rg="rg -g '!*.svg'" # exclude SVG
alias   rgh="rg --hidden"
alias   rgi="rg -i"
alias   rgl="rg -L"
alias  rghi="rgh -i"
alias  rghl="rgh -L"
alias  rgih="rghi"
alias  rgil="rgi -L"
alias  rglh="rghl"
alias  rgli="rgil"
alias rghil="rghi -L"
alias rghli="rghil"
alias rgihl="rghil"
alias rgilh="rghil"
alias rglhi="rghil"
alias rglih="rghil"

# Etc
alias       LS="sl"
alias cpufetch="cpufetch | lolcat -f"
alias linguist="github-linguist"
alias     pssh="pssh -iv -O StrictHostKeyChecking=no"

