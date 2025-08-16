#!/bin/sh
xrandr --output eDP-1 --brightness $(python -c "print(max(0, $(getbright) - 0.2))")
