#!/bin/bash

# A simple debounce script to prevent spamming
# Path to a temporary lock file
LOCK_FILE="/tmp/screenshot.lock"
# Path to your desired screenshot directory
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"

# Exit if the lock file exists (another instance is running)
if [ -e "$LOCK_FILE" ]; then
    exit 1
fi

# Create the lock file
touch "$LOCK_FILE"

# Run the grim and slurp command
FILENAME="$(date +%s_grim.png)"
grim -g "$(slurp)" "$SCREENSHOT_DIR/$FILENAME" && wl-copy < "$SCREENSHOT_DIR/$FILENAME"

# Remove the lock file when done, and ensure it is removed even on script exit
rm "$LOCK_FILE"
trap 'rm -f "$LOCK_FILE"' EXIT
