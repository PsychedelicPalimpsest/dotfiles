#!/bin/bash
while true; do
    name="$(find ~/.config/wallpapers/ -maxdepth 1 -type f ! -name "README.md" | shuf -n 1)"
    echo $name
    back4 0.1 "$name"&

    sleep 180
    kill $!
done
