#!/bin/sh

OPT0="Images and Videos"
OPT1="Only Images"
OPT2="Only Videos"


opt=$(printf "$OPT0\n$OPT1\n$OPT2\nred\nblue\ngreen\nhgreen\nblack" | dmenu -c -i -l 4) || exit 1
case "$opt" in 
  "$OPT0" ) opt=-1 ;;
  "$OPT1" ) opt=-2 ;;
  "$OPT2" ) opt=-3 ;;
  "black" ) opt=0 ;;
  "red" ) opt=$((0xFF0000)) ;;
  "green" ) opt=$((0x00FF00)) ;;
  "hgreen" ) opt=$((0x20C20E)) ;;
  "blue" ) opt=$((0x0000FF)) ;;

  # Some ugly ways to test for hex
  '#'[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F] ) 
    opt=$(( 0x${opt:1} ));;
  '#'[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F] ) 
    dig1=${opt:1:1}
    dig2=${opt:2:1}
    dig3=${opt:3:1}
    opt=$((  0x$dig1$dig1$dig2$dig2$dig3$dig3  ))
    ;;
  * )
    dunstify -u critical "Unknown background mode: $opt"
    exit 1
    ;;
esac

echo $opt > ~/.cache/.wallpaper_mode

pkill xwinwrap || true
pkill -x wallpaper  || true

sleep 0.2
wallpaper &
disown


