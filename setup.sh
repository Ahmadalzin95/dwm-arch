#!/usr/bin/env bash

# Variables
REPO_ROOT="$HOME/suckless"
THEME_NAME="Material-Black-Blueberry"
CURSOR_NAME="macOS"
THEME_FILE="$REPO_ROOT/assets/Material-Black-Blueberry-2.9.9-07.tar"
CURSOR_FILE="$REPO_ROOT/assets/macOS.tar.xz"

echo "Starting system setup"

# Install system dependencies
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm \
    base-devel git \
    xorg-server xorg-xinit mesa \
    libx11 libxinerama libxft libxrandr libxss \
    glib2 pango gtk3 gdk-pixbuf2 libxdg-basedir dbus \
    alacritty feh picom dunst libnotify \
    pipewire pipewire-pulse pipewire-alsa wireplumber bluez bluez-utils \
    brightnessctl pamixer \
    maim slop xclip xdotool nsxiv imagemagick \
    xorg-xset xorg-xrandr xorg-xrdb xorg-xsetroot xorg-setxkbmap xorg-xprop \
    adwaita-icon-theme unzip xdg-desktop-portal-gtk curl \
    autorandr arandr \
    ttf-jetbrains-mono-nerd

# Install AUR helper (yay) — needed for AUR packages below
if ! command -v yay >/dev/null 2>&1; then
    echo "Building yay (AUR helper)"
    YAY_TMP=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$YAY_TMP/yay"
    cd "$YAY_TMP/yay" && makepkg -si --noconfirm
    cd "$REPO_ROOT"
    rm -rf "$YAY_TMP"
fi

# AUR packages
yay -S --needed --noconfirm arc-gtk-theme gtk-engine-murrine

# Image viewer defaults
xdg-mime default nsxiv.desktop image/jpeg
xdg-mime default nsxiv.desktop image/png
xdg-mime default nsxiv.desktop image/gif

# Prepare directories
mkdir -p "$HOME/.config/dunst" "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0" \
         "$HOME/.themes" "$HOME/.icons" "$HOME/.local/bin" "$HOME/.dwm" \
         "$HOME/.local/share/fonts"

# Install i3lock-color (AUR)
yay -S --needed --noconfirm i3lock-color

# Betterlockscreen setup (AUR)
yay -S --needed --noconfirm betterlockscreen
FIXED_WALL="$REPO_ROOT/assets/lock-wp.jpg"
[ -f "$FIXED_WALL" ] && betterlockscreen -u "$FIXED_WALL" --fx blur

# Extract theme and icons
[ -f "$THEME_FILE" ] && tar -xf "$THEME_FILE" -C "$HOME/.themes/" && tar -xf "$THEME_FILE" -C "$HOME/.icons/"
if [ -f "$CURSOR_FILE" ]; then
    sudo mkdir -p /usr/share/icons
    sudo tar -xf "$CURSOR_FILE" -C /usr/share/icons/
fi

# Compile suckless tools
for tool in dwm dmenu slstatus; do
    if [ -d "$REPO_ROOT/$tool" ]; then
        echo "Installing $tool"
        cd "$REPO_ROOT/$tool" && sudo make clean install
    fi
done
cd "$REPO_ROOT"

# JetBrainsMono Nerd Font is installed via pacman (ttf-jetbrains-mono-nerd)
fc-cache -fv

# Link scripts and autostart
chmod +x "$REPO_ROOT/scripts/"*.sh
ln -sf "$REPO_ROOT/scripts/autostart.sh" "$HOME/.dwm/autostart.sh"
ln -sf "$REPO_ROOT/scripts/xinitrc" "$HOME/.xinitrc"

# GTK and Gnome configuration
cat <<EOF > "$HOME/.config/gtk-3.0/settings.ini"
[Settings]
gtk-theme-name=$THEME_NAME
gtk-icon-theme-name=$THEME_NAME
gtk-cursor-theme-name=$CURSOR_NAME
gtk-cursor-theme-size=24
gtk-font-name=JetBrainsMono Nerd Font 10
gtk-application-prefer-dark-theme=1
EOF
cp "$HOME/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"

# Wallust installation (AUR)
yay -S --needed --noconfirm wallust

# Wallust templates and config
mkdir -p "$HOME/.config/wallust/templates"
ASSETS_DIR="$REPO_ROOT/assets/wallust-setup"
if [ -d "$ASSETS_DIR" ]; then
    cp "$ASSETS_DIR/wallust.toml" "$HOME/.config/wallust/wallust.toml"
    cp "$ASSETS_DIR/xresources.template" "$HOME/.config/wallust/templates/"
    cp "$ASSETS_DIR/dunstrc.template" "$HOME/.config/wallust/templates/"
    cp "$ASSETS_DIR/sequences.template" "$HOME/.config/wallust/templates/"
fi

# Shell and Xresources integration
BASHRC_LINE='[ -f "$HOME/.cache/wallust/sequences" ] && source "$HOME/.cache/wallust/sequences"'
grep -qF "$BASHRC_LINE" "$HOME/.bashrc" || echo -e "\n$BASHRC_LINE" >> "$HOME/.bashrc"

cat <<EOF > "$HOME/.Xresources"
Xcursor.theme: $CURSOR_NAME
Xcursor.size: 24
#include "$HOME/.cache/wallust/colors.Xresources"
EOF
mkdir -p "$HOME/.cache/wallust"
touch "$HOME/.cache/wallust/colors.Xresources"

# TODO (Arch): optional Plymouth boot splash — needs the 'plymouth' hook in
# /etc/mkinitcpio.conf, 'plymouth-set-default-theme -R <theme>', and a
# 'splash quiet' kernel parameter in the bootloader. Handled as a separate step.

echo "Setup complete"