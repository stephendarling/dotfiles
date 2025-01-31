#!/usr/bin/env bash
sketchybar --add event aerospace_mode_change

sketchybar --subscribe aerospace.mode aerospace_mode_change \
    --set aerospace.mode \
    script="$CONFIG_DIR/plugins/aerospace_mode.sh $AEROSPACE_MODE"