#!/bin/bash

LOGFILE="$HOME/.config/yabai/logs/signal-application-front-switched.log"

exec >>$LOGFILE 2>&1

log() {
  local MESSAGE
  MESSAGE="[$(date +'%Y-%m-%d %H:%M:%S')] $@"
  echo $MESSAGE
}

pid=$YABAI_PROCESS_ID
wid=$(yabai -m query --windows | jq --arg pid "$pid" '.[] | select(.pid == ($pid | tonumber)) | .id')
yabai -m window $wid --focus
