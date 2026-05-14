#!/bin/bash

# --- Configuration ---
RECORD_DIR="/home/$USER/Videos/records"
LOCK_FILE="/tmp/gpu_recorder.lock"
NOTIFICATION_TAG="gpurec-toggle"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
OUTPUT_FILE="$RECORD_DIR/$TIMESTAMP.mp4"

mkdir -p "$RECORD_DIR"

if [ -f "$LOCK_FILE" ]; then
    pkill -SIGINT -x gpu-screen-recorder
    rm "$LOCK_FILE"
    sync
    notify-send -a "Recorder" -t 2000 -h "string:x-dunst-stack-tag:$NOTIFICATION_TAG" \
        "Recording Stopped" "Video saved to $RECORD_DIR"
    exit 0
fi

touch "$LOCK_FILE"
gpu-screen-recorder -w screen \
    -f 75 \
    -c mp4 \
    -q ultra \
    -k h264 \
    -a default_output \
    -v no \
    -o "$OUTPUT_FILE" &

notify-send -a "Recorder" -t 2000 -h "string:x-dunst-stack-tag:$NOTIFICATION_TAG" \
    "Recording Started" "75 FPS | Ultra MP4"
