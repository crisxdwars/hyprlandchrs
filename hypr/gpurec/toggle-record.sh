#!/bin/bash

# --- Configuration ---
# Output directory for the video files
RECORD_DIR="/home/chrs/Videos/records"
# Files to manage the running state (using absolute paths for robustness)
LOG_FILE="/tmp/gpu-screen-recorder.log"
PID_FILE="/tmp/gpu-screen-recorder.pid"

NOTIFICATION_TAG="gpurec-toggle" 
mkdir -p "$RECORD_DIR"

send_notification() {
    TITLE="$1"
    BODY="$2"
    notify-send -a "GPU Recorder" -i media-record -h "string:x-dunst-stack-tag:$NOTIFICATION_TAG" "$TITLE" "$BODY"
}

# Check if a PID file exists and the process is still running
if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
    # Recording is running, so stop it
    PID=$(cat "$PID_FILE")

    send_notification "Recording Stopped" "Video saved to: $RECORD_DIR"

    # Send SIGINT to gracefully stop the recording
    kill -SIGINT "$PID" 
    
    # Give the encoder a brief pause to finalize the file
    sleep 0.5 

    # Wait for the process to finish and clean up
    wait "$PID" 2>/dev/null
    rm "$PID_FILE"

else
    # Recording is not running, so start it

    # File name format: YYYY-MM-DD_HH-MM-SS.mkv
    TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
    OUTPUT_FILE="$RECORD_DIR/$TIMESTAMP.mp4" # Using .mp4 container as per your example

    # YOUR WORKING COMMAND, with dynamic output file
    gpu-screen-recorder -w screen -f 74 -a default_output -o "$OUTPUT_FILE" >> "$LOG_FILE" 2>&1 &
    
    # Save the PID of the last background process immediately
    echo $! > "$PID_FILE"

    send_notification "Recording Started" "\nOutput: $OUTPUT_FILE"

fi
