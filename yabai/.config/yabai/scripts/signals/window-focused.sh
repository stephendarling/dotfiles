# #!/bin/bash
#
# LOGFILE="$HOME/.config/yabai/logs/signals/window-focused.log"
#
# exec >>$LOGFILE 2>&1
#
# log() {
#   local MESSAGE
#   MESSAGE="[$(date +'%Y-%m-%d %H:%M:%S')] $@"
#   echo $MESSAGE
# }
#
# ID=$YABAI_WINDOW_ID
#
# CONFIG_FILE=$HOME/.config/yabai/config.json
#
# jq --arg id "$ID" \
#   '.history = (.history - [$id | tonumber] + [$id | tonumber])' \
#   "$CONFIG_FILE" | sponge "$CONFIG_FILE"
