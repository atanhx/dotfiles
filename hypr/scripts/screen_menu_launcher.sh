#!/bin/bash

XDG_SCREENSHOTS_DIR=${XDG_SCREENSHOTS_DIR:-$HOME/Pictures/Screenshots}
XDG_VIDEOS_DIR=${XDG_VIDEOS_DIR:-$HOME/Videos/Recordings}
PID_FILE="/tmp/wf-recorder.pid"

mkdir -p "$XDG_SCREENSHOTS_DIR"
mkdir -p "$XDG_VIDEOS_DIR"

wait_and_cleanup() {
    local pid_to_wait=$1
    local file_to_copy=$2
    (
        while kill -0 "$pid_to_wait" 2>/dev/null; do
            sleep 1
        done
        
        if [ -f "$file_to_copy" ]; then
            notify-send -t 1000 "Recording Stopped" "Video has been saved."
        fi

        pkill -f "/dev/video0"
        rm -f "$PID_FILE"
    ) &
}

if [ -f "$PID_FILE" ]; then
    notify-send -t 1000 "Stopping Screen Recording..."
    pkill -INT -F "$PID_FILE"
    exit 0
fi

choice=$(printf "  Screenshot Fullscreen\n  Screenshot Region\n   Record Fullscreen\n   Record Region\n  Record Fullscreen + Face Cam" | wofi -dmenu --sort-order -p "Capture")

REC_OPTS_HQ="--codec libx264rgb --crf 18 --preset faster -a=alsa_output.pci-0000_00_1f.3.analog-stereo.monitor"
MPV_CAM_CMD="mpv --profile=low-latency --untimed --vf=hflip --no-cache --hwdec=auto --no-osc --osd-level=0 --no-border --ontop /dev/video0"

case "$choice" in
    "  Screenshot Fullscreen")
        filepath="$XDG_SCREENSHOTS_DIR/$(date +'%Y-%m-%d_%H-%M-%S.png')"
        grimshot savecopy screen "$filepath"
        notify-send -t 1000 "Screenshot Taken" "Fullscreen capture copied to clipboard."
        ;;
    "  Screenshot Region")
        filepath="$XDG_SCREENSHOTS_DIR/$(date +'%Y-%m-%d_%H-%M-%S.png')"
        grimshot savecopy area "$filepath"
        notify-send -t 1000 "Screenshot Taken" "Region capture copied to clipboard."
        ;;
    "   Record Fullscreen")
        filepath="$XDG_VIDEOS_DIR/$(date +'%Y-%m-%d_%H-%M-%S.mp4')"
        notify-send -t 1000 "Starting Screen Recording" "Capturing fullscreen..."
        wf-recorder $REC_OPTS_HQ -f "$filepath" &
        recorder_pid=$!
        echo $recorder_pid > "$PID_FILE"
        wait_and_cleanup "$recorder_pid" "$filepath"
        ;;
    "   Record Region")
        geometry=$(slurp)
        if [ -n "$geometry" ]; then
            filepath="$XDG_VIDEOS_DIR/$(date +'%Y-%m-%d_%H-%M-%S.mp4')"
            notify-send -t 1000 "Starting Screen Recording" "Capturing selected region..."
            wf-recorder $REC_OPTS_HQ -g "$geometry" -f "$filepath" &
            recorder_pid=$!
            echo $recorder_pid > "$PID_FILE"
            wait_and_cleanup "$recorder_pid" "$filepath"
        fi
        ;;
    "  Record Fullscreen + Face Cam")
        $MPV_CAM_CMD &
        sleep 0.5
        filepath="$XDG_VIDEOS_DIR/$(date +'%Y-%m-%d_%H-%M-%S.mp4')"
        notify-send -t 1000 "Starting Screen Recording" "Capturing fullscreen with facecam..."
        wf-recorder $REC_OPTS_HQ -f "$filepath" &
        recorder_pid=$!
        echo $recorder_pid > "$PID_FILE"
        wait_and_cleanup "$recorder_pid" "$filepath"
        ;;
esac
