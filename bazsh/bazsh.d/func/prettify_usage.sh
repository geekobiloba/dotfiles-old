# Prettify usage function output

prettify_usage(){
  echo "$(usage)" |\
  awk '
    function print_line(){
      print gensub("{{([[:alnum:]]+)}}", "\\\\e[3m\\1\\\\e[m", "g")
    }

    # command title and option list
    NR == 1 || \
    $0 ~ /^[[:space:]]+-[[:alnum:]]+/ \
    {
      # embold the first word
      sub("[^[:space:]]+", "\\e[1m&\\e[m")

      print_line()
      next
    }

    # section titles
    $0 ~ /^[[:upper:][:space:][:punct:]]+$/ \
    {
      # embold the whole line
      sub("^", "\\e[1m")
      sub("$", "\\e[m" )

      print_line()
      next
    }

    # command usage lines
    $0 ~ /^[[:space:]]+[[:alnum:]]+/ \
    {
      # embold the first word
      sub("[^[:space:]]+", "\\e[1m&\\e[m")

      # embold options
      gsub("-[[:alnum:]]+", "\\e[1m&\\e[m")

      print_line()
      next
    }

    { print_line() }
  '
} # prettify_usage

print_usage(){
  printf '%b\n' "$(prettify_usage)"
} # print_usage

