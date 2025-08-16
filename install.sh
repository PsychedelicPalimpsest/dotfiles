#!/bin/bash

set -euo pipefail

# ==========================
#     Bash packages
# ==========================

LOC=$(dirname "$(realpath "$0")")

# Basic system packages
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm nvim git base-devel man xorg-xrandr \
  kitty blueman py3status superfile \
  dunst mpv feh picom gimp python-pip \
  pulseaudio-bluetooth ntfs-3g \
  xclip ttf-0xproto-nerd libnotify

# Enable Bluetooth service
sudo systemctl enable --now bluetooth

# Install Sublime Text if not already added
if ! grep -q '\[sublime-text\]' /etc/pacman.conf; then
  curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/pacman.d/sublimehq.gpg >/dev/null
  sudo pacman-key --add /etc/pacman.d/sublimehq.gpg
  sudo pacman-key --lsign-key 8A8F901A
  echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" |
    sudo tee -a /etc/pacman.conf
fi
sudo pacman -Syu --noconfirm sublime-text

# Install yay if not installed
if ! command -v yay &>/dev/null; then
  cd /tmp
  rm -rf yay-bin
  git clone https://aur.archlinux.org/yay-bin.git
  cd yay-bin
  makepkg -si --noconfirm
fi

# Build and install cmatrix
if ! command -v cmatrix &>/dev/null; then
  cd /tmp
  rm -rf cmatrix
  git clone https://github.com/abishekvashok/cmatrix.git
  cd cmatrix
  autoreconf -i
  ./configure
  make
  sudo make install
fi

# Build and install custom dmenu
if [ ! -d /tmp/dmenu ]; then
  cd /tmp
  git clone https://github.com/wellingtonctm/dmenu.git
  cd dmenu
  sudo make install
fi

# AUR packages
yay -S --noconfirm gscreenshot zen-browser-bin tty-clockc

# Set dark theme
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

# Nvim packer plugin
PACKER_PATH=~/.local/share/nvim/site/pack/packer/start/packer.nvim
if [ ! -d "$PACKER_PATH" ]; then
  git clone --depth 1 https://github.com/wbthomason/packer.nvim "$PACKER_PATH"
fi

# ==========================
#    Install my configs
# ==========================

cd "$LOC"

mkdir -p ~/.config/i3
ln -sf "$LOC/.aliases" ~/.aliases
ln -sf "$LOC/i3config" ~/.config/i3/config
ln -sf "$LOC/i3status.conf" ~/.config/i3/i3status.conf
ln -sf "$LOC/picom.conf" ~/.config/picom.conf

[ -f ~/.bashrc ] && rm -f ~/.bashrc
ln -sf "$LOC/.bashrc" ~/.bashrc

mkdir -p ~/.config/dunst
ln -sf "$LOC/dunstrc" ~/.config/dunst/dunstrc

mkdir -p ~/.config/kitty
ln -sf "$LOC/kitty.conf" ~/.config/kitty/kitty.conf

sudo install -m 755 toggle_backlight.sh /bin/toggle_backlight

ln -s "$LOC/superfile" ~/.config/

# ==========================
#    Install my utils
# ==========================

for script in getbright.sh upbright.sh downbright.sh wallpaper.sh no_sleep.sh can_sleep.sh show_off.sh shutdown_menu.sh dmenu_path.sh dmenu_run.sh; do
  sudo install -m 755 "$script" "/bin/${script%.sh}"
done

# ==========================
#  Install per-machine stuff
# ==========================

FAMILY="$(cat /sys/devices/virtual/dmi/id/product_family)"
if [ "$FAMILY" = "Slim 7 16IAH7" ]; then
  bash "$LOC/lenovo.sh"
  sudo install -m 755 get_preformence_mode.sh /bin/get_preformence_mode
  sudo install -m 755 preformence_menu.sh /bin/preformence_menu
fi

# ==========================
#     Setup zen
# ==========================

# Ensure zen has been run once
if [ ! -d "$HOME/.zen" ]; then
  zen-browser --headless &
  pid=$!
  sleep 3
  kill "$pid"
fi

# Configure Zen browser
ZEN_PROFILE_DIR=$(grep 'Path=' ~/.zen/profiles.ini | grep 'Default' | cut -d= -f2)
ZEN_PROFILE_PATH="$HOME/.zen/$ZEN_PROFILE_DIR"

rm -f "$ZEN_PROFILE_PATH/zen-themes.json"

mkdir -p "$ZEN_PROFILE_PATH/chrome"

ln -sf "$PWD/zen/userChrome.css" "$ZEN_PROFILE_PATH/chrome/userChrome.css"
ln -sf "$PWD/zen/user.js" "$ZEN_PROFILE_PATH/user.js"
ln -sf "$PWD/zen/zen-themes.json" "$ZEN_PROFILE_PATH/zen-themes.json"

sudo mkdir -p /etc/zen/policies
sudo install -m 644 "$PWD/zen/policies.json" /etc/zen/policies/policies.json

echo "✅ Reboot to see full changes."
