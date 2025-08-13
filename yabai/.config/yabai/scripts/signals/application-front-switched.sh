#!/bin/bash

LOGFILE="$HOME/.config/yabai/logs/signal-application-front-switched.log"

exec >>$LOGFILE 2>&1

log() {
  local MESSAGE
  MESSAGE="[$(date +'%Y-%m-%d %H:%M:%S')] $@"
  echo $MESSAGE
}

first=$YABAI_PROCESS_ID
second=$YABAI_RECENT_PROCESS_ID
