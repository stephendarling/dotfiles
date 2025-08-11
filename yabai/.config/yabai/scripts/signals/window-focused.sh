#!/bin/bash

LOGFILE="$HOME/.config/yabai/logs/signal-window-focused.log"

exec >>$LOGFILE 2>&1

log() {
  local MESSAGE
  MESSAGE="[$(date +'%Y-%m-%d %H:%M:%S')] $@"
  echo $MESSAGE
}

# window=$(yabai -m query --windows --window)
# window_id=$(jq '.id' <<<$window)
# stack_index=$(jq '."stack-index"' <<<$window)
#
# if ((stack_index > 0)); then
#   first_stack_window_id=$(yabai -m query --windows --window first.first | jq '.id')
#
#   if ((window_id != first_stack_window_id)); then
#     log "moving to top"
#     yabai -m window --stack stack.first --focus
#   fi
# fi
