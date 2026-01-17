#!/bin/bash

CURR="\"$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused).name')\""
TO="\"$1\""


i3-msg "rename workspace $CURR to \"temp\""
i3-msg "rename workspace $TO to $CURR" || true
i3-msg "rename workspace \"temp\" to $TO"


# Do I want this???
# i3-msg -- workspace --no-auto-back-and-forth $CURR

