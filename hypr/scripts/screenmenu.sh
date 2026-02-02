#!/usr/bin/env bash
set -euo pipefail

XDG_SCREENSHOTS_DIR="${XDG_SCREENSHOTS_DIR:-$HOME/Pictures/Screenshots}"
XDG_VIDEOS_DIR="${XDG_VIDEOS_DIR:-$HOME/Videos/Recordings}"
PID_FILE="/tmp/wf-recorder.pid"

REC_OPTS_HQ="--codec libx264rgb --crf 18 --preset faster -a=alsa_output.pci-0000_00_1f.3.analog-stereo.monitor"
MPV_CAM_CMD="mpv --profile=low-latency --untimed --vf=hflip --no-cache --hwdec=auto --no-osc --osd-level=0 --no-border --ontop /dev/video0"

wait_and_cleanup() {
    local recorder_pid=$1
    local filepath=$2
    local cam_pid=${3:-}

    (
        while kill -0 "$recorder_pid" 2>/dev/null; do
            sleep 1
        done

        if [[ -n "$cam_pid" ]]; then
            kill "$cam_pid" 2>/dev/null || true
        fi
        
        if [ -f "$filepath" ]; then
            notify-send -t 1000 "Recording Stopped" "Video has been saved."
        fi
        rm -f "$PID_FILE"
    ) &
}

start_recording() {
    local geometry=${1:-}
    local show_cam=${2:-false}
    local cam_pid=""
    local filepath="$XDG_VIDEOS_DIR/$(date +'%Y-%m-%d_%H-%M-%S.mp4')"

    if [[ "$show_cam" == true ]]; then
        $MPV_CAM_CMD &
        cam_pid=$!
        sleep 0.5 
    fi
    
    local cmd_args=($REC_OPTS_HQ)
    if [[ -n "$geometry" ]]; then
        cmd_args+=(-g "$geometry")
        notify-send -t 1000 "Starting Screen Recording" "Capturing selected region..."
    else
        notify-send -t 1000 "Starting Screen Recording" "Capturing fullscreen..."
    fi
    cmd_args+=(-f "$filepath")

    wf-recorder "${cmd_args[@]}" &
    local recorder_pid=$!
    
    echo "$recorder_pid" > "$PID_FILE"
    wait_and_cleanup "$recorder_pid" "$filepath" "$cam_pid"
}

take_screenshot() {
    local mode=$1
    local filepath="$XDG_SCREENSHOTS_DIR/$(date +'%Y-%m-%d_%H-%M-%S.png')"
    grimshot savecopy "$mode" "$filepath"
    notify-send -t 1000 "Screenshot Taken" "Capture copied to clipboard."
}

if [ -f "$PID_FILE" ]; then
    notify-send -t 1000 "Stopping Screen Recording..."
    pkill -INT -F "$PID_FILE"
    exit 0
fi

options="ss_full:  Screenshot (F)
ss_region:  Screenshot (R)
rec_full:  Record (F)
rec_region:  Record (R)
rec_cam:  Record (C)"

choice_text=$(echo "$options" | cut -d':' -f2 | /usr/bin/wofi --show dmenu)

if [[ -z "$choice_text" ]]; then
    exit 0
fi

key=$(echo "$options" | grep -F "$choice_text" | cut -d':' -f1)

mkdir -p "$XDG_SCREENSHOTS_DIR"
mkdir -p "$XDG_VIDEOS_DIR"

case "$key" in
    ss_full)
        take_screenshot "screen"
        ;;
    ss_region)
        take_screenshot "area"
        ;;
    rec_full)
        start_recording "" false
        ;;
    rec_region)
        geometry=$(slurp) || exit 1
        if [[ -n "$geometry" ]]; then
            start_recording "$geometry" false
        fi
        ;;
    rec_cam)
        start_recording "" true
        ;;
esac
