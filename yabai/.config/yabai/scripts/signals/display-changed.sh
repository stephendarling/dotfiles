#!/bin/bash

LOGFILE="$HOME/.config/yabai/logs/signal-display-changed.log"

exec >>$LOGFILE 2>&1

log() {
  local MESSAGE
  MESSAGE="[$(date +'%Y-%m-%d %H:%M:%S')] $@"
  echo $MESSAGE
}

display_width=$(yabai -m query --displays --display | jq '.frame.w | floor')
log "display width => $display_width"
toggle_script="$HOME/.config/yabai/scripts/actions/toggle-column-mode.sh"

if ((display_width >= 2500)); then
  log "width > 2500"
  $toggle_script 2
else
  log "width < 2500"
  $toggle_script 1
fi
