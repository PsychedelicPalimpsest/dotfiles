#!/bin/bash
CNT=$(systemd-inhibit --list | grep block | wc -l)

if [ "$CNT" -ne "0" ]; then
	echo Sleep hulted
else
	echo Sleep enable
fi