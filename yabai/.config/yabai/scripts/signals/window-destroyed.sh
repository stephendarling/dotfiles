#!/bin/bash

LOGFILE="$HOME/.config/yabai/logs/signal-window-destroyed.log"

exec >>$LOGFILE 2>&1

log() {
  local MESSAGE
  MESSAGE="[$(date +'%Y-%m-%d %H:%M:%S')] $@"
  echo $MESSAGE
}

# columns=$(defaults read com.koekeishiya.yabai columnMode)
# yabai -m window last --focus
# $HOME/.config/yabai/scripts/actions/toggle-column-mode.sh $columns
