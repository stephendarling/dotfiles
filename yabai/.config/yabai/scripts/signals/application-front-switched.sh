#!/bin/bash

LOGFILE="$HOME/.config/yabai/logs/signal-application-front-switched.log"

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
#
#
# new_pid=$YABAI_PROCESS_ID
# prev_pid=$YABAI_RECENT_PROCESS_ID
#
# config_file=$HOME/.config/yabai/config.json
#
# log "----------"
# log "---NEW----"
# log "----------"
#
# win_id=$(yabai -m query --windows | jq --arg pid "$new_pid" '.[] | select(.pid == ($pid | tonumber)).id')
# prev_win_id=$(yabai -m query --windows | jq --arg pid "$prev_pid" '.[] | select(.pid == ($pid | tonumber)).id')
#
# column_mode=$(cat $config_file | jq '.columnMode')
#
# if ((column_mode == 1)); then
#   prev_opacity=0.0000000000001
# else
#   prev_opacity=0.8
# fi
#
# yabai -m window $win_id --opacity 1.0
# yabai -m window $prev_win_id --opacity $prev_opacity
