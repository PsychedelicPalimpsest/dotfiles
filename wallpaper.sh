#!/bin/bash


MODE=$(($(get_wallpaper_mode raw)))




PAT=""
case $MODE in
    # Both image and video needs no pattern
    -1 ) ;;

    # Only Images, just excludes .gif
    -2 ) PAT="! -name *.gif" ;;

    # Only video, simply just gif
    -3 ) PAT="-name *.gif";;
    * )
        hsetroot -solid "#$(printf "%06x" $MODE)"
        sleep inf
        ;;
esac

while true; do
    name="$(find ~/.config/wallpapers/ -maxdepth 1 -type f $PAT ! -name "README.md" | shuf -n 1)"
    bg_set_wallpaper "$name"

    sleep 180
done
