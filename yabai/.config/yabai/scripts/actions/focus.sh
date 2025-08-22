#!/usr/bin/env bash

LOGFILE="$HOME/.config/yabai/logs/action-focus.log"

exec >>$LOGFILE 2>&1

log() {
  local MESSAGE
  MESSAGE="[$(date +'%Y-%m-%d %H:%M:%S')] $@"
  echo $MESSAGE
}

get_columns() {
  column_count=$(defaults read com.koekeishiya.yabai columnMode)
  log "total columns => $column_count"

  current_column=$(jq --arg wid "$current_wid" 'to_entries | .[] | select(.value[] | .id == ($wid | tonumber)) | (.key | tonumber)' <<<$layout)
  log "current column => $current_column"

  east_column=$((current_column + 1))
  if ((east_column > column_count)); then
    east_column=1
  fi
  log "east column => $east_column"

  west_column=$((current_column - 1))
  log "west column pre => $west_column"
  if ((west_column < 1)); then
    west_column=$column_count
  fi
  log "west column => $west_column"

  target_variable="${target_direction}_column"
  target_column=${!target_variable}
  log "target_column => $target_column"
}

log "---start---"

target_direction=$1

windows=$(yabai -m query --windows)
current_wid=$(jq '.[] | select(."has-focus") | .id' <<<$windows)
layout=$(jq 'map(select(."is-visible" == true)) | group_by(.frame.x) | to_entries | map({key: ((.key + 1) | tostring), value}) | from_entries' <<<$windows)
get_columns
focus_wid=$(jq --arg target_column "$target_column" '.[$target_column][0].id' <<<$layout)
yabai -m window $focus_wid --focus
# target_location_wid=$(yabai -m query --windows --window $direction | jq -e '.id' || yabai -m query --windows --window $wrap_direction | jq -e '.id')
# log "target location wid => $target_location_wid"
# target_location_column=$(get_window_column $target_location_wid)
# log "target location column => $target_location_column"
# stack_column_count=$(jq '.["1"] | length' <<<$layout)

# if ((column_count > 1 && stack_column_count == 1)); then
#   # swap
#   exit 0
# fi
#
# if ((column_count == 1)); then
#   exit 0
# fi
#
# if ((current_column != 1 && target_column != 1)); then
#   exit 0
#   # swap
# fi
#
# if ((current_column == 1 && target_column != 1)); then
#   exit 0
#   # log "move and replace"
#   # move_and_replace
# fi
#
# if ((current_colum != 1 && target_column == 1)); then
#   exit 0
#   # log "replace and move"
#   # replace_and_move
# fi
