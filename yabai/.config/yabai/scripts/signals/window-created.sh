#!/bin/bash

LOGFILE="$HOME/.config/yabai/logs/signal-window-created.log"

exec >>$LOGFILE 2>&1

log() {
  local MESSAGE
  MESSAGE="[$(date +'%Y-%m-%d %H:%M:%S')] $@"
  echo $MESSAGE
}

columns=$(defaults read com.koekeishiya.yabai columnMode)
log "columns => $columns"
if ((columns > 1)); then
  log "columns > 1"
  yabai -m window --grid 1:$columns:0:0:1:1
fi
