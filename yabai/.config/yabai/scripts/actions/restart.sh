#!/usr/bin/env bash

LOGFILE="$HOME/.config/yabai/logs/action-toggle-column-mode.log"

exec >>$LOGFILE 2>&1

log() {
  local MESSAGE
  MESSAGE="[$(date +'%Y-%m-%d %H:%M:%S')] $@"
  echo $MESSAGE
}

columns=$(defaults read com.koekeishiya.yabai columnMode)
yabai --restart-service
sleep 1
$HOME/.config/yabai/scripts/actions/toggle-column-mode.sh $columns
