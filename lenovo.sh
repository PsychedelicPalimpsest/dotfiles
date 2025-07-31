#!/bin/bash

# =========================== 
#  Install my laptop specific
#  control software 
# ===========================

# Quick saftey to make sure nobody nukes their laptops
FAMILY="$(cat /sys/devices/virtual/dmi/id/product_family)"
if [ "$FAMILY" != "Slim 7 16IAH7" ]; then
	echo Unsupported Device! Must be lenovo slim 7!
	exit 1
fi


# Get the quickec program
cd /tmp
wget https://raw.githubusercontent.com/PsychedelicPalimpsest/Lenovo-Slim-7/main/quickec.c || exit 1
gcc quickec.c -O2 -o quickec || exit 1

# Install it
sudo cp quickec /bin/quickec || exit 1

# Setup setuid so root is not needed
sudo chown root /bin/quickec || exit 1
sudo chmod u+s /bin/quickec || exit 1


echo Install successful


