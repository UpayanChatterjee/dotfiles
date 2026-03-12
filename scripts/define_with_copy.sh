#!/usr/bin/env bash

# Simulate Ctrl+C to copy selected text
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
  ydotool key 29:1 46:1 46:0 29:0 # Ctrl+C for Wayland
  sleep 0.2                       # Give time for clipboard to update
else
  xdotool key ctrl+c # Ctrl+C for X11
  sleep 0.1
fi

# Now get the word from clipboard
word=${1:-$(xclip -o -selection clipboard 2>/dev/null || wl-paste 2>/dev/null)}

# Rest of your script...
[[ -z "$word" || "$word" =~ [\/] ]] && notify-send -h string:bgcolor:#bf616a -t 3000 "Invalid input." && exit 0

query=$(curl -s --connect-timeout 5 --max-time 10 "https://api.dictionaryapi.dev/api/v2/entries/en_US/$word")
[ $? -ne 0 ] && notify-send -h string:bgcolor:#bf616a -t 3000 "Connection error." && exit 1
[[ "$query" == *"No Definitions Found"* ]] && notify-send -h string:bgcolor:#bf616a -t 3000 "Invalid word." && exit 0

def=$(echo "$query" | jq -r '[.[].meanings[] | {pos: .partOfSpeech, def: .definitions[].definition}] | .[:3].[] | "\n\(.pos). \(.def)"')
notify-send -t 60000 "$word -" "$def"
