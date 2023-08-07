# vim: set filetype=bash

pdfcat(){
  local PDF="$1"

  pdftotext -layout "$PDF" -
}

