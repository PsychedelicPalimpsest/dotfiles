#!/bin/bash

set -euo pipefail

# ==========================================
#
#        Desktop environment setup
#
# ==========================================

LOC=$(dirname "$(realpath "$0")")

# Basic system packages
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm nvim git base-devel man xorg-xrandr \
                            konsole firefox blueman

# Enable Bluetooth service
sudo systemctl enable --now bluetooth

# Install Sublime Text
curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/pacman.d/sublimehq.gpg > /dev/null
sudo pacman-key --add /etc/pacman.d/sublimehq.gpg
sudo pacman-key --lsign-key 8A8F901A
echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | \
    sudo tee -a /etc/pacman.conf
sudo pacman -Syu --noconfirm sublime-text

# Install yay
cd /tmp
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm

# AUR packages
yay -S --noconfirm gscreenshot

# Return to original script location
cd "$LOC"

# Install config file symlinks
mkdir -p ~/.config/i3
ln -sf "$LOC/.aliases" ~/.aliases
ln -sf "$LOC/i3config" ~/.config/i3/config

# Install brightness scripts
sudo install -m 755 getbright /bin/getbright
sudo install -m 755 upbright /bin/upbright
sudo install -m 755 downbright /bin/downbright

# Patch dmenu scripts
sudo install -m 755 dmenu_path /bin/dmenu_path
sudo install -m 755 dmenu_run /bin/dmenu_run
