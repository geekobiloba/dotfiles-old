alias    grep="ggrep -E --color"
alias     sed="gsed -r"
alias     awk="gawk"
alias  topmem="top -o -mem"
alias  topcpu="top -o -cpu"
alias  topcow="top -o -cow"
alias toptime="top -o -time"
alias  python="/opt/homebrew/bin/python3"
alias     dns="scutil --dns"
#alias   iperf="iperf3-darwin"

   [ $TERM_PROGRAM = Apple_Terminal ] \
|| [ $TERM_PROGRAM = iTerm.app      ] \
&& alias cls="osascript -e 'tell application \"System Events\" to tell process \"Terminal\" to keystroke \"k\" using command down'"

