#!/bin/bash

LOGFILE="$HOME/.config/yabai/logs/signal-window-destroyed.log"

exec >>$LOGFILE 2>&1

log() {
  local MESSAGE
  MESSAGE="[$(date +'%Y-%m-%d %H:%M:%S')] $@"
  echo $MESSAGE
}

yabai -m window recent --focus
yabai -m space recent --balance
