# Prettify help function output

_prettify_help(){
  echo "$(_help)" |\
  awk '
    function print_line(){
      # {{var}} --> variable      --> italics
      # <<str>> --> string option --> bold

      $0 = gensub("{{([^{}]+)}}", "\\\\e[3m\\1\\\\e[m", "g")
      $0 = gensub("<<([^<>]+)>>", "\\\\e[1m\\1\\\\e[m", "g")

      print
    }

    function embold_line(){
      sub("^", "\\e[1m")
      sub("$", "\\e[m" )
    }

    function embold_first_word(){
      sub("[^[:space:]]+", "\\e[1m&\\e[m")
    }

    function embold_options(){
      gsub("-[[:alnum:]]+", "\\e[1m&\\e[m")
    }

    # title and option list
    NR == 1 || \
    $0 ~ /^[[:space:]]+-[[:alnum:]]+/ \
    {
      embold_first_word()
      print_line()
      next
    }

    # section titles
    $0 ~ /^[[:upper:][:space:][:punct:]]+$/ \
    {
      embold_line()
      print_line()
      next
    }

    # usage lines
    $0 ~ /^[[:space:]]+[^[:space:]]+[[:space:]]{2,}/ \
    {
      embold_first_word()
      embold_options()
      print_line()
      next
    }

    { print_line() }
  '
} # _prettify_help

_print_help(){
  printf '%b\n' "$(_prettify_help)"
} # _print_help

_print_help_err(){
  printf '%b\n' "$(_prettify_help)" >&2
} # _print_help_err

