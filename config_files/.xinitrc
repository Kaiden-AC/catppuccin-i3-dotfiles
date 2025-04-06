#!/bin/sh
# ~/.xinitrc

# Set environment variables if needed
# export GDK_SCALE=2 # Example for HiDPI

# Set keyboard layout (optional, can also be set in i3 config)
# setxkbmap us &

# Start keychain or other session managers if needed
# eval $(keychain --eval --quiet id_rsa) &

# Start the window manager
exec i3
