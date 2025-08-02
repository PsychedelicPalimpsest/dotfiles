#!/bin/bash

set -euo pipefail

# ==========================
#     Bash packages
# ==========================

LOC=$(dirname "$(realpath "$0")")

# Basic system packages
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm nvim git base-devel man xorg-xrandr \
                            kitty blueman py3status \
                            dunst mpv feh picom

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


# Better dmenu
cd /tmp
git clone https://github.com/wellingtonctm/dmenu.git
cd dmenu
sudo make install


# AUR packages
yay -S --noconfirm gscreenshot zen-browser-bin
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"



# ==========================
#    Install my configs
# ==========================


cd "$LOC"

# Install config file symlinks
mkdir -p ~/.config/i3
ln -sf "$LOC/.aliases" ~/.aliases
ln -sf "$LOC/i3config" ~/.config/i3/config
ln "$LOC/i3status.conf" ~/.config/i3/i3status.conf
ln "$LOC/picom.conf" ~/.config/picom.conf


rm -f ~/.bashrc
ln "$LOC/.bashrc" ~/.bashrc

mkdir -p ~/.config/dunst/
ln "$LOC/dunstrc" ~/.config/dunst/dunstrc

mkdir -p ~/.config/kitty/
ln "$LOC/kitty.conf" ~/.config/kitty/kitty.conf


# ==========================
#    Install my utils
# ==========================


# Install brightness scripts
sudo install -m 755 getbright /bin/getbright
sudo install -m 755 upbright /bin/upbright
sudo install -m 755 downbright /bin/downbright


sudo install -m 755 wallpaper.sh /bin/wallpaper



# Patch dmenu scripts
sudo install -m 755 dmenu_path /bin/dmenu_path
sudo install -m 755 dmenu_run /bin/dmenu_run



# Install stuff specific to my machine
FAMILY="$(cat /sys/devices/virtual/dmi/id/product_family)"
if [ "$FAMILY" = "Slim 7 16IAH7" ]; then
	sh "$LOC/lenovo.sh"

    sudo install -m 755 get_preformence_mode /bin/get_preformence_mode
    sudo install -m 755 preformence_menu /bin/preformence_menu
fi


# ==========================
#     Setup zen
# ==========================

# Ensure zen has been run at least once to create the profile
zen-browser --headless &
pid=$!
sleep 3
kill "$pid"


# Find default profile
ZEN_PROFILE_DIR=$(grep 'Path=' ~/.zen/profiles.ini | grep Default\ \( | cut -d= -f2)
ZEN_PROFILE_PATH="$HOME/.zen/$ZEN_PROFILE_DIR"
rm "$ZEN_PROFILE_PATH/zen-themes.json"

mkdir -p "$ZEN_PROFILE_PATH/chrome"

ln -sf "$PWD/zen/userChrome.css" "$ZEN_PROFILE_PATH/chrome/userChrome.css"
ln -sf "$PWD/zen/user.js" "$ZEN_PROFILE_PATH/user.js"
ln -sf "$PWD/zen/zen-themes.json" "$ZEN_PROFILE_PATH/zen-themes.json"

# Set policies
sudo mkdir -p /etc/zen/policies
sudo install -m 644 "$PWD/zen/policies.json" /etc/zen/policies/policies.json


echo Reboot to see full changes