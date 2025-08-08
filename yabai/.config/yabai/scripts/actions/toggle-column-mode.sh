LOGFILE="$HOME/.config/yabai/logs/actions/toggle-column-mode.log"

exec >>$LOGFILE 2>&1

log() {
  local MESSAGE
  MESSAGE="[$(date +'%Y-%m-%d %H:%M:%S')] $@"
  echo $MESSAGE
}

createColumns() {
  OTHER_VISIBLE_WINDOWS=$(yabai -m query --windows | jq 'map(select((."is-visible" == true) and ."is-floating" == false and ."has-focus" == false ))')
  FOCUSED_WINDOW_ID=$(yabai -m query --windows | jq 'map(select(."has-focus" == true)) | .[0].id')
  TOTAL_WINDOWS=$(($(jq length <<<$OTHER_VISIBLE_WINDOWS) + 1))

  yabai -m config --space $SPACE_ID layout bsp

  if [ $TOTAL_WINDOWS -gt $COLUMNS ]; then
    PREVIOUS_WINDOWS=$(yabai -m query --windows --space $SPACE_ID prev | jq 'map(select(."is-visible" == true))')
    index=0
    jq -c '.[]' <<<$PREVIOUS_WINDOWS | while read i; do
      WINDOW_ID=$(echo $i | jq .id)
      if [ $((index + 1)) -gt $COLUMNS ]; then
        STACK_WINDOW_ID=$(jq --arg i "$((index - 1))" '.[$i | tonumber].id' <<<$PREVIOUS_WINDOWS)
        log "index +1 greater than columns for window $WINDOW_ID"
        yabai -m window $STACK_WINDOW_ID --insert stack
        yabai -m window $WINDOW_ID --warp $STACK_WINDOW_ID
        yabai -m window $WINDOW_ID --raise $STACK_WINDOW_ID
      fi
      ((index++))
    done
  fi

  yabai -m space $SPACE_ID --mirror y-axis
  yabai -m space $SPACE_ID --balance

}

SPACE_ID=$(
  yabai -m query --windows | jq 'map(select(."has-focus" == true)) | .[0].space'
)

COLUMNS=$1

case $COLUMNS in
1)
  yabai -m config --space $SPACE_ID layout stack
  ;;
*)
  createColumns
  ;;
esac

defaults write com.user.yabai.settings columnMode -int $1
log "Set columnMode to $1"
