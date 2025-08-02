#!/bin/bash


opt=$(printf "Poweroff\nRestart\nLogout" | dmenu -c -i -l 3) || exit 1
case "$opt" in
	"Poweroff" )
	poweroff ;;
	"restart" )
	restart ;;
	"Logout" )
	i3-msg exit ;;
esac
