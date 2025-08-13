#!/bin/bash

LOGFILE="$HOME/.config/yabai/logs/signal-window-focused.log"

exec >>$LOGFILE 2>&1

log() {
  local MESSAGE
  MESSAGE="[$(date +'%Y-%m-%d %H:%M:%S')] $@"
  echo $MESSAGE
}

windows=$(yabai -m query --windows)
focused_wid=$(echo "$windows" | jq 'map(select(."has-focus"))[0].id')
visible_column_wids=$(echo "$windows" | jq '[map(select(."is-visible")) | group_by(.frame.x) | map(.[0].id)[]]')

echo "$windows" | jq -c '.[]' | while read -r window; do
  id=$(echo "$window" | jq '.id')
  opacity=""

  if [[ "$id" == "$focused_wid" ]]; then
    opacity="1.0"
  elif [[ $(echo "$visible_column_wids" | jq "contains([$id])") == "true" ]]; then
    opacity="0.8"
  else
    opacity="0.2"
  fi

  yabai -m window "$id" --opacity "$opacity"
done