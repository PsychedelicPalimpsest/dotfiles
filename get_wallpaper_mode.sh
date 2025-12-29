#!/bin/sh



# Fallback
MODE=-1
if [ -f ~/.cache/.wallpaper_mode ]; then
  MODE=$(($( cat ~/.cache/.wallpaper_mode )))
fi



case $MODE in 
  -1 ) STR="Images and Videos" ;;
  -2 ) STR="Only Images" ;;
  -3 ) STR="Only Videos" ;;
  * ) 
    COLOR=$(printf '%06x' $MODE)
    STR="Solid #$COLOR" ;;
esac
    



if [ "raw" == "$1" ]; then
  echo $MODE
else 
  echo $STR
fi
