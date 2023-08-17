# naughty neofetch
# Safe to alias naughtyfetch=neofetch

naughtyfetch(){
  local IMAGE="$1"
  local WIDTH="$2"
  local CHARS="$3"

  paste \
    <(
      jp2a \
        --colors \
        --color-depth=24 \
        --width="$WIDTH" \
        --chars="$CHARS" \
        "$IMAGE"
    ) \
    <(
      command neofetch \
        --off \
        --memory_display infobar \
        --bar_char \
          '█' \
          '░' \
        --bar_length 32 \
      | lolcat -f 
    )
}

