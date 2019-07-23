#!/bin/sh

other=$(xrandr -q | grep "connected" | grep -v eDP-1-1)

xrandr --output eDP-1-1 --primary --mode 3840x2160 --scale 1.0x1.0 --dpi 220 --rotate normal $(echo "$other" | awk '{print "--output", $1, "--off"}' | tr '\n' ' ')
