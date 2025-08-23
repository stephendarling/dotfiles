#!/usr/bin/env bash

LOGFILE="$HOME/.config/yabai/logs/action-toggle-column-mode.log"

exec >>$LOGFILE 2>&1

log() {
  local MESSAGE
  MESSAGE="[$(date +'%Y-%m-%d %H:%M:%S')] $@"
  echo $MESSAGE
}

# create_columns() {
#   VISIBLE_WINDOWS=$(jq 'map(select((."is-visible" == true) and ."is-floating" == false))' <<<$windows)
#   TOTAL_WINDOWS=$(jq 'length' <<<$VISIBLE_WINDOWS)
#   STACK_WINDOW_INDEX=$((columns - 1))
#   STACK_WINDOW_ID=$(jq --arg swi "$STACK_WINDOW_INDEX" '.[($swi | tonumber)].id' <<<$VISIBLE_WINDOWS)
#
#   yabai -m config --space $space_id layout bsp
#
#   if ((TOTAL_WINDOWS <= columns)); then
#     yabai -m space $space_id --mirror y-axis
#   else
#     VISIBLE_IDS=$(jq 'map(.id)' <<<$VISIBLE_WINDOWS)
#     history_ids=()
#     while IFS= read -r line; do
#       history_ids+=("$line")
#     done < <(jq '.[]' <<<$VISIBLE_IDS)
#
#     for i in "${!history_ids[@]}"; do
#       window_num=$((i + 1))
#       id=${history_ids[i]}
#
#       if [[ $i == 0 ]]; then
#         yabai -m window $id --warp last
#       fi
#
#       if [[ $i -gt 0 ]]; then
#         prev_index=$((i - 1))
#         prev_id=${history_ids[prev_index]}
#
#         if ((window_num <= COLUMNS)); then
#           yabai -m window $id --warp $prev_id
#         fi
#
#         if [[ $window_num -gt $COLUMNS ]]; then
#           yabai -m window $prev_id --insert stack
#           yabai -m window $id --warp $prev_id
#           # yabai -m window stack.last --stack $id
#           yabai -m window $prev_id --stack $id
#         fi
#       fi
#     done
#
#   fi
#
#   yabai -m space $SPACE_ID --balance
# }

create_grid() {
  window=1
  window_count=$(jq '. | length' <<<$windows)

  jq -c '.[]' <<<$windows |
    while read -r window_json; do
      log "Processing window $window of $window_count"

      id=$(echo "$window_json" | jq '.id')
      app=$(echo "$window_json" | jq -r '.app') # -r gets the raw string value
      title=$(echo "$window_json" | jq -r '.title')

      log "Processing window ID: $id, App: $app, Title: '$title'"

      if ((window == 1)); then
        yabai -m window $id --grid 1:$columns:1:0:1:1
      else
        yabai -m window $id --grid 1:$columns:0:0:1:1
      fi

      ((window++))
    done
}

windows=$(yabai -m query --windows)
space_id=1

columns=$1

case $columns in
1)
  yabai -m config --space $space_id layout stack
  ;;
*)
  yabai -m config --space $space_id layout float
  create_grid
  ;;
esac

defaults write com.koekeishiya.yabai columnMode -int "$columns"
