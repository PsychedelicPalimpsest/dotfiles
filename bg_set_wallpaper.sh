#!/usr/bin/env bash
# wallpaper.sh — unified static/dynamic wallpaper wrapper
# Uses xgifwallpaper for GIFs and feh for everything else.

file="$1"

if [[ -z "$file" ]]; then
    echo "Usage: $0 /path/to/image.(jpg|png|jpeg|gif)"
    exit 1
fi

# Kill any previous wallpaper processes to avoid layering
pkill xgifwallpaper 2>/dev/null

# Detect file type by extension
case "${file,,}" in
    *.gif)
        if ! command -v xgifwallpaper  >/dev/null; then
            echo "Error: xgifwallpaper not found. Install it first."
            exit 1
        fi
        # Set animated GIF wallpaper
        nohup xgifwallpaper "$file" -s FILL >/dev/null 2>&1 &
        ;;
    *)
        if ! command -v feh >/dev/null; then
            echo "Error: feh not found. Install it first."
            exit 1
        fi
        # Set static wallpaper with feh
        feh --bg-fill "$file"
        ;;
esac
