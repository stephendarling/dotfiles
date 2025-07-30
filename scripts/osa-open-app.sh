#!/bin/bash

APP_NAME="$1"

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

delay 0.2

tell application "System Events"
	keystroke "h" using { option down, control down }
end tell
EOF
