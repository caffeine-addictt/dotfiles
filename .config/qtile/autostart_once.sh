#!/bin/bash

# Monitor arrangements
xrandr --output eDP-1-1 --primary --mode 1920x1080 --pos 0x0 --output HDMI-1-2 --mode 1920x1080 --right-of eDP-1-1

# Apply wallpaper using wal
wal -b 282738 -i ~/Wallpaper/Aesthetic2.png &

# Start picom
picom --config ~/.config/picom/picom.conf &

# Easyeffects
easyeffects --gapplication-service &

# Set default audio sinks
MIC_NAME="alsa_input.usb-0c76_USB_PnP_Audio_Device-00.mono-fallback"
MIC_NODE_ID=$(wpctl status --name | grep "$MIC_NAME" | awk '{print $2}' | head -n1 | sed 's/\.$//')
if [ -n "$MIC_NODE_ID" ]; then
  wpctl set-default "$MIC_NODE_ID"
else
  echo "Warning: Microphone '$MIC_NAME' not found."
fi

# Start clipster daemon
clipster -d

