# vim: filetype=bash

_prettify-help(){

  # Caller script
  local _CMD_="$(basename $0)"

  _help_ |\
  awk \
    -v cmd="$_CMD_" \
  '
    function bold(str){
      return "\\e[1m" str "\\e[m"
    }
    function italic(str){
      return "\\e[3m" str "\\e[m"
    }
    function uline(str){
      return "\\e[4m" str "\\e[m"
    }
    function print_line(){

      # Option with an optional argument.
      # They must be separated by exactly a single space.
      $0 = gensub( \
        "([ [])(-[[:alnum:]] ?)([[:alnum:]_]+)?",  \
        "\\1\\" bold("\\2\\") "\\" italic("\\3\\"), \
        "g" \
      )

      # Caller script
      $0 = gensub(cmd, "\\" bold("&\\"), "g")

      # *bold text*
      $0 = gensub("\\*(.+)\\*", "\\" bold("\\1\\"), "g")

      # _italic text_
      $0 = gensub("_(.+)_", "\\" italic("\\1\\"), "g")

      # <underline text>
      $0 = gensub("<(.+)>", "\\" uline("\\1\\"), "g")

      print
    }

    # Header
    /^[[:upper:] -]+$/ {
      sub(".+", bold("&"), $1)
      print
      next
    }

    # Other lines
    {print_line()}
  '
}

print-help(){
  printf '%b\n' "$(_prettify-help)"
  exit
}

print-help-err(){
  printf '%b\n' "$(_prettify-help)" >&2
  exit 1
}

