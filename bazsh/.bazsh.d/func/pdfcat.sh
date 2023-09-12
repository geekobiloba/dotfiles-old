# View PDF as text

pdfcat(){
  local PDF="$1"

  pdftotext -layout "$PDF" -
}

