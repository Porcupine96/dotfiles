#!/usr/bin/env bash

DIR="$HOME/.config/polybar"

# Terminate already running bar instances
killall polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done


if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    t=$(xrandr --query | grep "$m connected primary" >> /dev/null && echo "right" || echo "none")
    TRAY_POSITION=$t MONITOR=$m polybar --reload -q main -c "$DIR"/config.ini &
  done
else
  polybar --reload -q main -c "$DIR"/config.ini &
fi
