#!/bin/bash

PID_FILE="/tmp/wf-recorder.pid"

if [ -f "$PID_FILE" ]; then
    start_time=$(ps -p "$(cat "$PID_FILE")" -o lstart=)
    if [ -n "$start_time" ]; then
        start_seconds=$(date -d "$start_time" +%s)
        current_seconds=$(date +%s)
        duration=$((current_seconds - start_seconds))
        printf "%02d:%02d" $((duration / 60)) $((duration % 60))
    else
        echo ""
    fi
else
    echo ""
fi
