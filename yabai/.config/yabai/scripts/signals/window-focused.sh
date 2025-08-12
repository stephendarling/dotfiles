#!/bin/bash

LOGFILE="$HOME/.config/yabai/logs/signal-window-focused.log"

exec >>$LOGFILE 2>&1

log() {
  local MESSAGE
  MESSAGE="[$(date +'%Y-%m-%d %H:%M:%S')] $@"
  echo $MESSAGE
}

wid=$YABAI_WINDOW_ID
windows=$(yabai -m query --windows)
layout=$(jq 'map(select(."is-visible" == true)) | group_by(.frame.x) | to_entries | map({key: ((.key + 1) | tostring), value}) | from_entries' <<<$windows)
column_keys=$(jq 'keys | .[]' <<<$layout)

columns=()
while IFS= read -r line; do
  columns+=("$line")
done < <(jq 'keys | .[]' <<<$layout)

visible=()
for i in "${columns[@]}"; do
  visible_id=$(jq --arg i "$i" ".[$i][0].id" <<<$layout)
  visible+=($visible_id)
done

all_windows=()
while IFS= read -r line; do
  all_windows+=($line)
done < <(jq '.[] | select(."is-visible" == true) | .id' <<<$windows)

for i in "${all_windows[@]}"; do
  if ((i == wid)); then
    opacity=1.0
  elif [[ " ${visible[*]} " =~ " $i " ]]; then
    opacity=0.8
  else
    opacity=0.2
  fi

  yabai -m window $i --opacity $opacity
done
