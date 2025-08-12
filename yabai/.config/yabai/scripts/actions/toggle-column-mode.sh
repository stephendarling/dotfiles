#!/usr/bin/env bash

LOGFILE="$HOME/.config/yabai/logs/action-toggle-column-mode.log"

exec >>$LOGFILE 2>&1

log() {
  local MESSAGE
  MESSAGE="[$(date +'%Y-%m-%d %H:%M:%S')] $@"
  echo $MESSAGE
}

createColumns() {
  VISIBLE_WINDOWS=$(jq 'map(select((."is-visible" == true) and ."is-floating" == false))' <<<$windows)
  TOTAL_WINDOWS=$(jq 'length' <<<$VISIBLE_WINDOWS)
  STACK_WINDOW_INDEX=$((COLUMNS - 1))
  STACK_WINDOW_ID=$(jq --arg swi "$STACK_WINDOW_INDEX" '.[($swi | tonumber)].id' <<<$VISIBLE_WINDOWS)

  yabai -m config --space $space_id layout bsp

  if [ $TOTAL_WINDOWS -gt $COLUMNS ]; then
    VISIBLE_IDS=$(jq 'map(.id)' <<<$VISIBLE_WINDOWS)
    history_ids=()
    while IFS= read -r line; do
      history_ids+=("$line")
    done < <(jq '.[]' <<<$VISIBLE_IDS)

    for i in "${!history_ids[@]}"; do
      window_num=$((i + 1))
      id=${history_ids[i]}

      if [[ $i == 0 ]]; then
        yabai -m window $id --warp last
      fi

      if [[ $i -gt 0 ]]; then
        prev_index=$((i - 1))
        prev_id=${history_ids[prev_index]}

        if ((window_num <= COLUMNS)); then
          yabai -m window $id --warp $prev_id
        fi

        if [[ $window_num -gt $COLUMNS ]]; then
          yabai -m window $prev_id --insert stack
          yabai -m window $id --warp $prev_id
          # yabai -m window stack.last --stack $id
          yabai -m window $prev_id --stack $id
        fi
      fi
    done

  fi

  yabai -m space $SPACE_ID --balance
}

CONFIG_FILE=$HOME/.config/yabai/config.json
windows=$(yabai -m query --windows)
window=$(yabai -m query --windows --window)
space_id=$(jq '.space' <<<$window)

COLUMNS=$1

case $COLUMNS in
1)
  yabai -m config --space $space_id layout stack
  ;;
*)
  createColumns
  ;;
esac

jq --arg c "$COLUMNS" '.columnMode = ($c | tonumber)' "$CONFIG_FILE" | sponge "$CONFIG_FILE"
