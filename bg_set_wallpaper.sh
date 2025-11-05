#!/usr/bin/env bash
# bg_set_wallpaper — animated wallpaper with proper stacking for i3, etc.

file="$1"

if [[ -z "$file" ]]; then
    echo "usage: $0 /path/to/file.(gif|mp4|webm|jpg|png)"
    exit 1
fi

# Kill any existing wallpaper instances
pkill xwinwrap 2>/dev/null
sleep 0.1

case "$file" in
    *.gif|*.mp4|*.webm)
        # Launch video wallpaper "below" all normal windows
        nohup xwinwrap -ni -fs -un -b -nf -ov -- mpv \
            --wid=%WID \
            --loop-file=inf \
            --no-audio \
            --no-osc \
            --no-input-default-bindings \
            --no-border \
            --really-quiet \
            --no-sub \
            --no-window-dragging \
            --panscan=1.0 \
            --no-keepaspect-window \
            --geometry=100%x100% \
            --vd-lavc-threads=2 \
            --cache=yes \
            --cache-pause=no \
            --cache-secs=10 \
            "$file" >/dev/null 2>&1 &


        ;;
    *)
        feh --bg-fill "$file"
        ;;
esac
