#!/usr/bin/env bash

LOGFILE="$HOME/.config/yabai/logs/action-move.log"

exec >>"$LOGFILE" 2>&1

log() {
  local MESSAGE
  MESSAGE="[$(date +'%Y-%m-%d %H:%M:%S')] $@"
  echo "$MESSAGE"
}

get_window_column() {
  # This function works as-is, operating on the $layout variable
  local column
  column=$(jq --arg wid "$1" 'to_entries | .[] | select(.value[] | .id == ($wid | tonumber)) | (.key | tonumber)' <<<"$layout")
  echo "$column"
}

# --- Action functions (move_and_replace, replace_and_move, swap) are unchanged ---
move_and_replace() {
  yabai -m window "$target_location_wid" --insert stack
  yabai -m window "$wid" --warp "$target_location_wid"
  # This jq query is now more robust, checking for the existence of a second window
  current_stack_prev_wid=$(jq --arg c "$current_column" 'if .[$c] and .[$c][1] then .[$c][1].id else empty end' <<<"$layout")
  if [[ -n "$current_stack_prev_wid" ]]; then
    yabai -m window "$current_stack_prev_wid" --insert stack
    yabai -m window "$target_location_wid" --warp "$current_stack_prev_wid"
    yabai -m window "$current_stack_prev_wid" --stack "$target_location_wid"
  fi
}

replace_and_move() {
  yabai -m window "$wid" --insert stack
  yabai -m window "$target_location_wid" --warp "$wid"
  # This jq query is also now more robust
  target_stack_prev_wid=$(jq --arg c "$target_location_column" 'if .[$c] and .[$c][1] then .[$c][1].id else empty end' <<<"$layout")
  if [[ -n "$target_stack_prev_wid" ]]; then
    yabai -m window "$target_stack_prev_wid" --insert stack
    yabai -m window "$wid" --warp "$target_stack_prev_wid"
  fi
}

swap() {
  log "Attempting swap: direction => $direction, wrap => $wrap_direction, opp => $opp_direction"
  yabai -m window --swap "$direction" || yabai -m window --swap "$wrap_direction" || yabai -m window --swap "$opp_direction"
}

# --- Main Script Logic ---

log "---start (optimized)---"

direction=$1

if [[ $direction == "west" ]]; then
  wrap_direction="last"
  opp_direction="east"
else
  wrap_direction="first"
  opp_direction="west"
fi

# =================================================================
# OPTIMIZATION: Query yabai only ONCE and store the result.
# =================================================================
all_windows_json=$(yabai -m query --windows)

# --- Derive all subsequent variables from the stored JSON ---

# Get the ID of the focused window
wid=$(jq 'map(select(."has-focus" == true)) | .[0].id' <<<"$all_windows_json")

# Build the column layout from the full window list
layout=$(jq '[.[] | select(."is-visible" == true and ."is-floating" == false)] | group_by(.frame.x) | to_entries | map({key: ((.key+1)|tostring), value}) | from_entries' <<<"$all_windows_json")

# Get current window's column number
current_column=$(get_window_column "$wid")
if [[ -z "$current_column" ]]; then
  log "❌ Could not determine current column for WID $wid. Exiting."
  exit 1
fi
log "Current column => $current_column"

# Logically determine the target window's column and ID
total_columns=$(jq 'length' <<<"$layout")

if [[ $direction == "west" ]]; then
  target_column=$((current_column - 1))
  if ((target_column < 1)); then target_column=$total_columns; fi # Wrap to last
else                                                              # east
  target_column=$((current_column + 1))
  if ((target_column > total_columns)); then target_column=1; fi # Wrap to first
fi

# Get the target WID from the layout (first window in the target column)
target_location_wid=$(jq --arg tc "$target_column" '.[$tc][0].id' <<<"$layout")
target_location_column=$target_column
# =================================================================
# END OPTIMIZATION
# =================================================================

log "Target location wid => $target_location_wid"
log "Target location column => $target_location_column"

# --- The rest of the script's logic remains the same ---
stack_column_count=$(jq '.["1"] | length' <<<"$layout")
columns=$(jq '.columnMode' "$HOME/.config/yabai/config.json")

if ((columns > 1 && stack_column_count <= 1 && current_column == 1)); then
  swap
  exit 0
fi

if ((columns <= 1)); then
  exit 0
fi

if ((current_column != 1 && target_location_column != 1)); then
  swap
fi

if ((current_column == 1 && target_location_column != 1)); then
  log "Move and replace"
  move_and_replace
fi

if ((current_column != 1 && target_location_column == 1)); then
  log "Replace and move"
  replace_and_move
fi
