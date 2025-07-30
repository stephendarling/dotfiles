#!/bin/bash

APP_NAME="$1"
LAPTOP_KEY="h"
ULTRAWIDE_KEY="k"

# Detect screen width
MODE=$(cat ~/.display_mode)

# Choose key based on screen
if [ "$MODE" == "laptop" ]; then
  KEY="$LAPTOP_KEY"
else
  KEY="$ULTRAWIDE_KEY"
fi

osascript <<EOF
do shell script "open -a \\"$APP_NAME\\""

tell application "System Events"
	repeat until exists (application process "$APP_NAME")
		delay 0.1
	end repeat

	repeat until frontmost of application process "$APP_NAME" is true
		delay 0.1
	end repeat
end tell

delay 0.5

tell application "System Events"
	keystroke "$KEY" using { option down, control down }
end tell
EOF
