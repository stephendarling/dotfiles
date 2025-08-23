#!/bin/bash

LOGFILE="$HOME/.config/yabai/logs/signal-window-destroyed.log"

exec >>$LOGFILE 2>&1

log() {
  local MESSAGE
  MESSAGE="[$(date +'%Y-%m-%d %H:%M:%S')] $@"
  echo $MESSAGE
}

columns=$(defaults read com.koekeishiya.yabai columnMode)
windows=$(yabai -m query --windows)
recent_window_id=$(jq '.[0].id' <<<$windows)
log "recent window id => $recent_window_id"
yabai -m window $recent_window_id --focus
$HOME/.config/yabai/scripts/actions/toggle-column-mode.sh $columns
