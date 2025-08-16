#!/bin/bash

PIDFILE="/tmp/nosleep.pid"

SLP=$(printf "Sleep\nNo Sleep" | dmenu -c -i -l 2) || exit 1

# If nosleep is active, stop it
if [ -f "$PIDFILE" ]; then
    PID=$(cat "$PIDFILE")
    if kill -0 "$PID" 2>/dev/null; then
        kill "$PID"
    fi
    rm -f "$PIDFILE"
fi

# Start inhibitor if selected
if [ "$SLP" = "No Sleep" ]; then
    # Inhibit sleep
    systemd-inhibit --what=sleep --who="User Disabled" --why="User temporary block" sleep infinity &
    echo $! > "$PIDFILE"
    disown

    # Disable screen lock
    xset s off -dpms s noblank
    dunstify "Sleeping and screen locking disabled"
else
    # Re-enable screen lock settings
    xset s on +dpms s blank
    dunstify "Sleeping and screen locking enabled"
fi
