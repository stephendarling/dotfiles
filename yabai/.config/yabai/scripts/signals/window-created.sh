#!/bin/bash

LOGFILE="$HOME/.config/yabai/logs/signals/window-created.log"

exec >>$LOGFILE 2>&1

log() {
  local MESSAGE
  MESSAGE="[$(date +'%Y-%m-%d %H:%M:%S')] $@"
  echo $MESSAGE
}

ID=$YABAI_WINDOW_ID
log "Begin Event => $ID"

VISIBLE_WINDOWS=$(yabai -m query --windows | jq 'map(select((."is-visible" == true) and ."is-floating" == false ))')
NUM_VISIBLE_WINDOWS=$(jq 'length' <<<$VISIBLE_WINDOWS)

log "Visible Windows == $NUM_VISIBLE_WINDOWS"

if [[ $NUM_VISIBLE_WINDOWS -gt 2 ]]; then
  STACK_TARGET_ID=$(yabai -m query --windows --window sibling | jq .id)
  log "Target Window => $STACK_TARGET_ID"
  yabai -m window $STACK_TARGET_ID --insert stack
  yabai -m window $ID --warp $STACK_TARGET_ID
  log "Stacking on sibling of first window"
fi
