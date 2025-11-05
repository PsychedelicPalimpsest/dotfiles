#!/bin/bash
while true; do
    name="$(find ~/.config/wallpapers/ -maxdepth 1 -type f -name *.gif ! -name "README.md" | shuf -n 1)"
    echo $name
    bg_set_wallpaper "$name"

    sleep 180
done
