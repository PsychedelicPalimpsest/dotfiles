#!/bin/sh
xrandr --current --verbose | grep Brightness | cut -d ":" -f2-
