#!/bin/sh


# See: 
# 	ITSM @ https://github.com/PsychedelicPalimpsest/Lenovo-Slim-7/blob/main/ram%20map.md

MODE=$(quickec get preformence_mode)

if [ "$MODE" -eq 1 ]; then
	echo Intelligent Cooling
elif [ "$MODE" = 2 ]; then
	echo Power Save
elif [ "$MODE" = 4 ]; then
	echo Extreme Performance
else
	echo UNKNOWN
fi
