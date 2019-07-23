#!/bin/sh
xrandr \
    --output eDP-1-1 --primary --mode 3840x2160 --pos 6000x992 --scale 1x1 --rotate normal \
    --output DP-1.1 --mode 1920x1080 --pos 0x520 --scale 2x2 --rotate normal \
    --output DP-0 --mode 1920x1080 --pos 3840x0 --scale 2x2 --rotate right
