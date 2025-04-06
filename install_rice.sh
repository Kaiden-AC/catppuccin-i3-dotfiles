#!/bin/bash

# install_rice.sh - Installs Catppuccin Mocha i3 Rice on Arch Linux

# Exit immediately if a command exits with a non-zero status.
set -euo pipefail

# --- Configuration ---
WALLPAPER_URL="https://raw.githubusercontent.com/VipinVIP/wallpapers/main/landscapes/yosemite.png"
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
WALLPAPER_NAME="yosemite.png"
CONFIG_DIR_SRC="$(pwd)/config_files" # Assumes config_files is in the same dir as the script

# --- Helper Functions ---
info() {
    echo -e "\e[34m[INFO]\e[0m $1"
}

warning() {
    echo -e "\e[33m[WARN]\e[0m $1"
}

error() {
    echo -e "\e[31m[ERROR]\e[0m $1"
    exit 1
}

# --- Checks ---
if [[ ! -d "$CONFIG_DIR_SRC" ]]; then
    error "Configuration directory '$CONFIG_DIR_SRC' not found. Make sure it exists and contains the config files."
fi

if [[ "$EUID" -eq 0 ]]; then
   error "This script should not be run as root. Run it as your regular user."
fi

# --- Package Lists ---
PACMAN_PACKAGES=(
    # Core WM & Utilities
    i3-gaps           # Window manager
    polybar           # Status bar
    rofi              # Application launcher
    alacritty         # Terminal emulator
    dunst             # Notification daemon
    picom             # Compositor
    nitrogen          # Graphical wallpaper setter (alternative to feh)
    feh               # Simple wallpaper setter (used in i3 config)
    thunar            # GUI File Manager
    thunar-archive-plugin
    thunar-volman
    gvfs              # Needed for Thunar trash/volume management
    lxappearance      # GTK theme switcher
    neovim            # Text editor
    nano              # Simple text editor
    git               # Version control (needed for yay, config fetching)
    base-devel        # Needed for building AUR packages
    xorg-server       # Xorg server
    xorg-xinit        # For starting X session with startx
    xorg-xrandr       # For display management
    # Fonts & Icons
    ttf-jetbrains-mono-nerd # Font with icons
    noto-fonts        # General purpose fonts
    papirus-icon-theme # Icon theme
    # Audio
    pipewire          # Modern audio server (recommended)
    pipewire-pulse    # PulseAudio replacement layer for PipeWire
    pipewire-alsa
    wireplumber       # PipeWire session manager
    pavucontrol       # GUI audio mixer
    pamixer           # CLI audio mixer (for keybindings)
    # System & Convenience
    networkmanager    # Network management daemon
    nm-applet         # System tray applet for NetworkManager
    brightnessctl     # Control screen brightness (laptops)
    flameshot         # Screenshot tool
    betterlockscreen  # Fancy lockscreen
    imagemagick       # Required by betterlockscreen
    unzip             # For extracting archives
    wget              # For downloading files (like wallpaper)
    curl              # For downloading files
    ranger            # TUI File Manager (optional)
    ueberzug          # Image previews for ranger (optional)
    bluez             # Bluetooth stack (optional)
    bluez-utils       # Bluetooth utilities (optional)
    blueman           # Bluetooth GUI manager (optional)
    # Add a browser if you don't have one
    # firefox
    # chromium
)

AUR_PACKAGES=(
    catppuccin-gtk-theme-mocha # GTK theme (check exact name on AUR if needed)
    papirus-folders-catppuccin # Papirus folder icons with Catppuccin colors
    # yay               # AUR Helper - we install this manually first
)

# --- Installation ---
info "Updating system packages..."
sudo pacman -Syu --noconfirm || warning "Full system upgrade failed. Continuing..."

info "Installing core packages from official repositories..."
# Use --needed to avoid reinstalling existing packages
sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"

# Install AUR Helper (yay)
if ! command -v yay &> /dev/null; then
    info "Installing AUR helper (yay)..."
    if ! pacman -Q git > /dev/null 2>&1; then sudo pacman -S --needed --noconfirm git; fi
    if ! pacman -Q base-devel > /dev/null 2>&1; then sudo pacman -S --needed --noconfirm base-devel; fi
    cd /tmp
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si --noconfirm
    cd ..
    rm -rf yay-bin
    info "yay installed successfully."
else
    info "AUR helper (yay) already installed."
fi

info "Installing AUR packages..."
# Check if packages exist before trying to install
installed_aur=$(yay -Qqm)
packages_to_install=()
for pkg in "${AUR_PACKAGES[@]}"; do
    if ! echo "$installed_aur" | grep -q "^$pkg$"; then
        packages_to_install+=("$pkg")
    else
        info "$pkg is already installed."
    fi
done

if [ ${#packages_to_install[@]} -gt 0 ]; then
    yay -S --needed --noconfirm "${packages_to_install[@]}"
else
    info "All required AUR packages are already installed."
fi


# --- Configuration Setup ---
info "Creating configuration directories..."
mkdir -p ~/.config/{i3,polybar,rofi,alacritty,dunst,picom,gtk-3.0,gtk-4.0,ranger}
mkdir -p ~/.local/share/fonts
mkdir -p "$WALLPAPER_DIR"

info "Backing up existing configs (if any)..."
CONFIG_FILES_TARGET=("$HOME/.config/i3" "$HOME/.config/polybar" "$HOME/.config/rofi" "$HOME/.config/alacritty" "$HOME/.config/dunst" "$HOME/.config/picom" "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0" "$HOME/.config/ranger" "$HOME/.gtkrc-2.0" "$HOME/.xinitrc")
for target in "${CONFIG_FILES_TARGET[@]}"; do
    if [ -e "$target" ]; then
        info "Backing up $target to ${target}.bak"
        mv "$target" "${target}.bak_$(date +%F_%T)" || warning "Could not backup $target"
    fi
done

info "Copying new configuration files..."
# Be specific to avoid accidentally copying unwanted files
cp -r "$CONFIG_DIR_SRC/i3" ~/.config/
cp -r "$CONFIG_DIR_SRC/polybar" ~/.config/
cp -r "$CONFIG_DIR_SRC/rofi" ~/.config/
cp -r "$CONFIG_DIR_SRC/alacritty" ~/.config/
cp -r "$CONFIG_DIR_SRC/dunst" ~/.config/
cp -r "$CONFIG_DIR_SRC/picom" ~/.config/
cp -r "$CONFIG_DIR_SRC/ranger" ~/.config/ # Optional Ranger config

# GTK config files (ensure these exist in config_files dir)
if [ -f "$CONFIG_DIR_SRC/gtk-3.0/settings.ini" ]; then
    cp "$CONFIG_DIR_SRC/gtk-3.0/settings.ini" ~/.config/gtk-3.0/
fi
if [ -f "$CONFIG_DIR_SRC/gtk-4.0/settings.ini" ]; then
    cp "$CONFIG_DIR_SRC/gtk-4.0/settings.ini" ~/.config/gtk-4.0/
fi
if [ -f "$CONFIG_DIR_SRC/.gtkrc-2.0" ]; then
    cp "$CONFIG_DIR_SRC/.gtkrc-2.0" ~/
fi

# .xinitrc for startx
if [ -f "$CONFIG_DIR_SRC/.xinitrc" ]; then
    cp "$CONFIG_DIR_SRC/.xinitrc" ~/
fi


info "Setting permissions for scripts..."
chmod +x ~/.config/polybar/launch.sh
chmod +x ~/.config/i3/scripts/* # If you add scripts later

info "Downloading wallpaper..."
wget -O "$WALLPAPER_DIR/$WALLPAPER_NAME" "$WALLPAPER_URL" || warning "Failed to download wallpaper. Please set one manually."

# --- System Configuration ---
info "Setting GTK Theme, Icons, and Font using GSettings (may require login/logout)..."
# Use gsettings for GTK3/4 apps (like Nautilus, Gnome apps)
# Adjust theme name if the AUR package installs it differently
GTK_THEME="Catppuccin-Mocha-Standard-Blue-Dark"
ICON_THEME="Papirus-Dark" # Papirus-Dark often looks good with dark themes
FONT_NAME="Noto Sans 10"  # Default UI font

gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME" || warning "gsettings: Failed to set GTK theme. Use lxappearance manually."
gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME" || warning "gsettings: Failed to set icon theme. Use lxappearance manually."
gsettings set org.gnome.desktop.interface font-name "$FONT_NAME" || warning "gsettings: Failed to set default font."
# For cursor theme:
# gsettings set org.gnome.desktop.interface cursor-theme 'YourCursorTheme'

info "Applying Papirus Catppuccin folder colors..."
# Check if papirus-folders command exists and the theme variant is installed
if command -v papirus-folders &> /dev/null && papirus-folders -l | grep -q catppuccin-mocha; then
    papirus-folders -C catppuccin-mocha --theme Papirus-Dark
else
    warning "papirus-folders command not found or Catppuccin variant missing. Cannot set folder colors automatically."
fi

info "Enabling NetworkManager service..."
sudo systemctl enable NetworkManager.service

info "Setting up betterlockscreen cache..."
# This needs to run after i3 starts ideally, but we can try priming it.
# It might fail if Xorg is not running.
if [ -f "$WALLPAPER_DIR/$WALLPAPER_NAME" ]; then
   info "Attempting to prime betterlockscreen cache (may require running 'betterlockscreen -u \"$WALLPAPER_DIR/$WALLPAPER_NAME\"' after login)."
   # Check if DISPLAY is set, might not work from TTY
   if [[ -n "${DISPLAY-}" ]]; then
       betterlockscreen -u "$WALLPAPER_DIR/$WALLPAPER_NAME" &> /dev/null || warning "Priming betterlockscreen failed. Run manually after login."
   else
       warning "DISPLAY not set. Cannot prime betterlockscreen cache now. Run manually after login."
   fi
else
    warning "Wallpaper not found, skipping betterlockscreen cache setup."
fi

# --- Final Steps ---
info "Installation complete!"
echo "-----------------------------------------------------"
info "IMPORTANT NEXT STEPS:"
echo "1. If you are in a TTY, you can now likely start the i3 session by typing: startx"
echo "2. If you have a display manager (like LightDM, GDM, SDDM), log out and select 'i3' as your session."
echo "3. After logging in, you might want to:"
echo "   - Run 'lxappearance' to visually confirm/tweak GTK themes, icons, and fonts."
echo "   - Run 'pavucontrol' to manage audio devices."
echo "   - Run 'blueman-manager' or 'bluetoothctl' to manage Bluetooth devices (if installed)."
echo "   - Change the wallpaper using 'nitrogen' or by editing ~/.config/i3/config and restarting i3 (Mod+Shift+r)."
echo "   - Update the lockscreen wallpaper: betterlockscreen -u \"$WALLPAPER_DIR/$WALLPAPER_NAME\""
echo "   - Rebooting ('sudo reboot') might be necessary for some changes (like audio drivers or system services) to take full effect."
echo "-----------------------------------------------------"

exit 0
