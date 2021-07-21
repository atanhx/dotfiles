#!/bin/sh

~/bin/eww daemon &
nm-applet --indicator &
picom &
dunst &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
feh --bg-fill ~/Pictures/Wallpapers/sunset4k.jpg &
blueman &
#enable touchpad tapping and natural scrolling
xinput set-prop "AlpsPS/2 ALPS GlidePoint" "libinput Tapping Enabled" 1
xinput set-prop "AlpsPS/2 ALPS GlidePoint" "libinput Natural Scrolling Enabled" 1
notify-send "Logined As Uday"