#!/bin/bash


# ==========================================
#
#        Desktop enviroment setup
#
# ==========================================


LOC=$(dirname $(realpath $0))

# Some packages
sudo pacman -S nvim git base-devel man xorg-xrandr \
              konsole firefox blueman


sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# Sublime text

curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
sudo pacman -Syu sublime-text

# Setup yay
cd /tmp
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si



yay -S gscreenshot


cd $LOC

# Install config file symlinks
ln .aliases ~/.aliases || true
ln i3config ~/.config/i3/config || true


# Simply brightness commands
sudo cp getbright /bin/
sudo cp upbright /bin/
sudo cp downbright /bin/

sudo chmod +x /bin/getbright
sudo chmod +x /bin/upbright
sudo chmod +x /bin/downbright



# Patch dmenu to work with .aliases file
sudo cp dmenu_path /bin/dmenu_path
sudo cp dmenu_run /bin/dmenu_run
