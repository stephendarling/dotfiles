#!/usr/bin/env bash

LOGFILE="$HOME/.config/yabai/logs/action-open-app.log"

exec >>$LOGFILE 2>&1

log() {
  local MESSAGE
  MESSAGE="[$(date +'%Y-%m-%d %H:%M:%S')] $@"
  echo $MESSAGE
}

app=$1
log "Trying to open $app"
windows=$(yabai -m query --windows)

wid=$(jq -e --arg app "$app" 'first(.[] | select(.app == $app)) | .id' <<<$windows || echo 0)
log "wid => $wid"

if ((wid == 0)); then
  log "window now found, opening"
  open -na "$app"
else
  log "window found, focusing"
  yabai -m window $wid --focus
fi
