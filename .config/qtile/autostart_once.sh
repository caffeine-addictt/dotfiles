#!/bin/bash

# Monitor arrangements
xrandr --output eDP-1-1 --primary --mode 1920x1080 --pos 0x0 --output HDMI-1-2 --mode 1920x1080 --right-of eDP-1-1

# Apply wallpaper using wal
wal -b 282738 -i ~/Wallpaper/Aesthetic2.png &

# Start picom
picom --config ~/.config/picom/picom.conf &

# Start clipster daemon
clipster -d

