#!/bin/bash

battery_level=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n 1)
battery_status=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -n 1)

if [[ "$battery_level" -le 15 && "$battery_status" == "Discharging" ]]; then
    notify-send -u critical "Battery Critical" "Battery level is ${battery_level}%"
fi
