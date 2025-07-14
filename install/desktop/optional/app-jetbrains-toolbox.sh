#!/bin/bash

# Install JetBrains Toolbox following official recommendations
set -e

# Check if already installed
if [ -d ~/.local/share/JetBrains/Toolbox ]; then
  echo "JetBrains Toolbox is already installed!"
  echo "You can run 'jetbrains-toolbox' to launch it."
  exit 0
fi

echo "Installing JetBrains Toolbox..."

# Create necessary directories
mkdir -p ~/.local/share/JetBrains/Toolbox/bin
mkdir -p ~/.local/bin

# Download the latest JetBrains Toolbox AppImage
cd /tmp
wget --show-progress -qO jetbrains-toolbox.tar.gz "https://data.services.jetbrains.com/products/download?platform=linux&code=TBA"

# Extract the AppImage
TOOLBOX_TEMP_DIR=$(mktemp -d)
tar -C "$TOOLBOX_TEMP_DIR" -xf jetbrains-toolbox.tar.gz
rm jetbrains-toolbox.tar.gz

# Move the binary to the proper location
mv "$TOOLBOX_TEMP_DIR"/*/jetbrains-toolbox ~/.local/share/JetBrains/Toolbox/bin/jetbrains-toolbox
chmod +x ~/.local/share/JetBrains/Toolbox/bin/jetbrains-toolbox

# Create symlink if ~/.local/bin is in PATH
if [[ ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
  ln -sf ~/.local/share/JetBrains/Toolbox/bin/jetbrains-toolbox ~/.local/bin/jetbrains-toolbox
fi

# Clean up
rm -rf "$TOOLBOX_TEMP_DIR"

echo "JetBrains Toolbox installed successfully!"
echo "Starting JetBrains Toolbox for initial setup..."

# Run toolbox to complete setup (creates desktop entry, etc.)
~/.local/share/JetBrains/Toolbox/bin/jetbrains-toolbox &

echo "JetBrains Toolbox is now running in the background."
echo "You can now install JetBrains IDEs (Rider, IntelliJ, etc.) through the Toolbox."
echo "The Toolbox will appear in your application menu and system tray." 