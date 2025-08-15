#!/usr/bin/env bash

LOGFILE="$HOME/.config/yabai/logs/action-move.log"

exec >>$LOGFILE 2>&1

log() {
  local MESSAGE
  MESSAGE="[$(date +'%Y-%m-%d %H:%M:%S')] $@"
  echo $MESSAGE
}

get_window_column() {
  local column=$(jq --arg wid "$1" 'to_entries | .[] | select(.value[] | .id == ($wid | tonumber)) | (.key | tonumber)' <<<$layout)
  echo $column
}

move_and_replace() {
  yabai -m window $target_location_wid --insert stack
  yabai -m window $wid --warp $target_location_wid
  current_stack_prev_wid=$(jq --arg c "$current_column" '.[$c][1].id' <<<$layout)
  yabai -m window $current_stack_prev_wid --insert stack
  yabai -m window $target_location_wid --warp $current_stack_prev_wid
  yabai -m window $current_stack_prev_wid --stack $target_location_wid
}

replace_and_move() {
  yabai -m window $wid --insert stack
  yabai -m window $target_location_wid --warp $wid
  target_stack_prev_wid=$(jq --arg c "$target_location_column" '.[$c][1].id' <<<$layout)
  yabai -m window $target_stack_prev_wid --insert stack
  yabai -m window $wid --warp $target_stack_prev_wid
}

swap() {
  log "direction => $direction, wrap => $direction, opp => $opp_direction"
  yabai -m window --swap $direction || yabai -m window --swap $wrap_direction || yabai -m window --swap $opp_direction
}

log "---start---"

direction=$1

if [[ $direction == "west" ]]; then
  wrap_direction="last"
  opp_direction="east"
else
  wrap_direction="first"
  opp_direction="west"
fi

log "direction => $direction, wrap => $wrap_direction"

wid=$(yabai -m query --windows --window | jq '.id')
layout=$(yabai -m query --windows | jq ' map(select(."is-visible" == true)) | group_by(.frame.x) | to_entries | map({key: ((.key + 1) | tostring), value}) | from_entries')
current_column=$(get_window_column $wid)
log "current column => $current_column"
target_location_wid=$(yabai -m query --windows --window $direction | jq -e '.id' || yabai -m query --windows --window $wrap_direction | jq -e '.id')
log "target location wid => $target_location_wid"
target_location_column=$(get_window_column $target_location_wid)
log "target location column => $target_location_column"
stack_column_count=$(jq '.["1"] | length' <<<$layout)
columns=$(defaults read com.koekeishiya.yabai columnMode)

if ((columns > 1 && stack_column_count == 1)); then
  swap
  exit 0
fi

if ((columns == 1)); then
  exit 0
fi

if ((current_column != 1 && target_location_column != 1)); then
  swap
fi

if ((current_column == 1 && target_location_column != 1)); then
  log "move and replace"
  move_and_replace
fi

if ((current_colum != 1 && target_location_column == 1)); then
  log "replace and move"
  replace_and_move
fi

