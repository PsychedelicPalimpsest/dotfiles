#!/bin/bash

# Ensure Firefox has been run at least once to create the profile
firefox --headless & sleep 3; kill $!

# Find default profile
FIREFOX_PROFILE_DIR=$(grep 'Path=' ~/.mozilla/firefox/profiles.ini | grep default-release | cut -d= -f2)
FIREFOX_PROFILE_PATH="$HOME/.mozilla/firefox/$FIREFOX_PROFILE_DIR"

mkdir -p "$FIREFOX_PROFILE_PATH/chrome"

ln -sf "$PWD/firefox/userChrome.css" "$FIREFOX_PROFILE_PATH/chrome/userChrome.css"
ln -sf "$PWD/firefox/user.js" "$FIREFOX_PROFILE_PATH/user.js"

# Set policies
sudo mkdir -p /etc/firefox/policies
sudo install -m 644 "$PWD/firefox/policies.json" /etc/firefox/policies/policies.json
