#!/bin/bash


# See: 
# 	ITSM @ https://github.com/PsychedelicPalimpsest/Lenovo-Slim-7/blob/main/ram%20map.md


opt=$(printf "Power Save\nIntelligent Cooling\nExtreme Performance" | dmenu -c -i -l 3) || exit 1


dunstify "$opt activated"


case "$opt" in 
	"Power Save" )
		quickec set preformence_mode 2 ;;
	"Intelligent Cooling" )
		quickec set preformence_mode 1 ;;
	"Extreme Performance" )
		quickec set preformence_mode 4 ;;
esac

