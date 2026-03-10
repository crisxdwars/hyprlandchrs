#!/bin/bash

# --- Configuration ---
RECORD_DIR="/home/chrs/Videos/records"
LOG_FILE="/tmp/gpu-screen-recorder.log"
PID_FILE="/tmp/gpu-screen-recorder.pid"

NOTIFICATION_TAG="gpurec-toggle" 
mkdir -p "$RECORD_DIR"

send_notification() {
    TITLE="$1"
    BODY="$2"
    notify-send -a "Screen Recorder" -i media-record -h "string:x-dunst-stack-tag:$NOTIFICATION_TAG" "$TITLE" "$BODY"
}

if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
    PID=$(cat "$PID_FILE")

    send_notification "Recording Stopped" "Video saved!"

    kill -SIGINT "$PID" 
    
    sleep 0.5 

    wait "$PID" 2>/dev/null
    rm "$PID_FILE"

else

    TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
    OUTPUT_FILE="$RECORD_DIR/$TIMESTAMP.mp4" # Using .mp4 container as per your example

    gpu-screen-recorder -w screen -f 74 -a default_output -o "$OUTPUT_FILE" >> "$LOG_FILE" 2>&1 &
    
    echo $! > "$PID_FILE"

    send_notification "Recording Started!"

fi
