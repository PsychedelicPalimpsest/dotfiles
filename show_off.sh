#!/bin/bash

# Start in a known state — set horizontal split
# i3-msg split h

# Start left window: pipes.sh
kitty pipes.sh -p 5 -R &

# Wait a bit to let i3 place the window
sleep 0.2

# Start right window: cmatrix
kitty cmatrix -m &

# Wait again to ensure window is placed
sleep 0.2

# Focus right (cmatrix window)
i3-msg focus right

# Now split the cmatrix window vertically
i3-msg split v

# Launch tty-clock below cmatrix
kitty tty-clock -sSB &
