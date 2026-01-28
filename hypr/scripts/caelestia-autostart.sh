#!/bin/bash
# Auto-restart Caelestia shell if it crashes
while true; do
    caelestia shell -d
    sleep 2
done
