# macOS - Clear terminal buffer

clk(){
  if # iTerm or Apple Terminal
    [ $TERM_PROGRAM = iTerm.app      ] ||\
    [ $TERM_PROGRAM = Apple_Terminal ]
  then
    osascript \
      -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
  else
    clear
  fi
}
