#!/bin/bash

# Install JetBrains Toolbox following official recommendations

# Function to handle errors and cleanup
cleanup() {
    local exit_code=$?
    echo "Cleaning up temporary files..."
    if [ -n "$TOOLBOX_TEMP_DIR" ] && [ -d "$TOOLBOX_TEMP_DIR" ]; then
        rm -rf "$TOOLBOX_TEMP_DIR"
        echo "Removed temporary directory: $TOOLBOX_TEMP_DIR"
    fi
    if [ -f /tmp/jetbrains-toolbox.tar.gz ]; then
        rm -f /tmp/jetbrains-toolbox.tar.gz
        echo "Removed temporary download file"
    fi
    if [ $exit_code -ne 0 ]; then
        echo "Installation failed with exit code $exit_code"
        echo "Please check the error messages above and try again."
    fi
    exit $exit_code
}

# Set up error handling
trap cleanup EXIT
set -e

echo "=== JetBrains Toolbox Installation ==="

# Check if already installed
if [ -d ~/.local/share/JetBrains/Toolbox ]; then
    echo "JetBrains Toolbox is already installed!"
    echo "Installation directory: ~/.local/share/JetBrains/Toolbox"
    if command -v jetbrains-toolbox >/dev/null 2>&1; then
        echo "Command 'jetbrains-toolbox' is available in PATH"
    else
        echo "Warning: 'jetbrains-toolbox' command not found in PATH"
    fi
    exit 0
fi

echo "Step 1: Creating necessary directories..."
mkdir -p ~/.local/share/JetBrains/Toolbox/bin
mkdir -p ~/.local/bin
echo "✓ Directories created"

echo "Step 2: Downloading JetBrains Toolbox..."
cd /tmp

# Check if wget is available
if ! command -v wget >/dev/null 2>&1; then
    echo "Error: wget is not installed. Please install wget and try again."
    exit 1
fi

# Download with better error handling
echo "Downloading from JetBrains servers..."
if ! wget --show-progress -qO jetbrains-toolbox.tar.gz "https://data.services.jetbrains.com/products/download?platform=linux&code=TBA"; then
    echo "Error: Failed to download JetBrains Toolbox"
    echo "Please check your internet connection and try again."
    exit 1
fi

# Verify download
if [ ! -f jetbrains-toolbox.tar.gz ]; then
    echo "Error: Download file not found"
    exit 1
fi

file_size=$(stat -c%s jetbrains-toolbox.tar.gz)
if [ "$file_size" -lt 1000000 ]; then  # Less than 1MB is suspicious
    echo "Error: Downloaded file seems too small ($file_size bytes)"
    echo "This might indicate a download error or server issue."
    exit 1
fi

echo "✓ Download completed ($file_size bytes)"

echo "Step 3: Extracting archive..."
TOOLBOX_TEMP_DIR=$(mktemp -d)
echo "Using temporary directory: $TOOLBOX_TEMP_DIR"

if ! tar -C "$TOOLBOX_TEMP_DIR" -xf jetbrains-toolbox.tar.gz; then
    echo "Error: Failed to extract archive"
    echo "The downloaded file might be corrupted."
    exit 1
fi

rm jetbrains-toolbox.tar.gz
echo "✓ Archive extracted"

echo "Step 4: Finding and installing Toolbox..."
# Find the toolbox directory
TOOLBOX_DIR=$(find "$TOOLBOX_TEMP_DIR" -type d -name "jetbrains-toolbox-*" | head -1)
if [ -z "$TOOLBOX_DIR" ]; then
    echo "Error: Could not find jetbrains-toolbox directory in downloaded archive"
    echo "Archive contents:"
    ls -la "$TOOLBOX_TEMP_DIR"
    exit 1
fi

echo "Found toolbox directory: $TOOLBOX_DIR"

# Verify the binary exists
TOOLBOX_BINARY_IN_ARCHIVE=$(find "$TOOLBOX_DIR" -name "jetbrains-toolbox" -type f)
if [ -z "$TOOLBOX_BINARY_IN_ARCHIVE" ]; then
    echo "Error: Could not find jetbrains-toolbox binary in archive"
    echo "Directory contents:"
    find "$TOOLBOX_DIR" -type f
    exit 1
fi

echo "Found binary: $TOOLBOX_BINARY_IN_ARCHIVE"

# Remove the empty bin directory we created and move the complete installation
rm -rf ~/.local/share/JetBrains/Toolbox/bin
if ! mv "$TOOLBOX_DIR" ~/.local/share/JetBrains/Toolbox/; then
    echo "Error: Failed to move toolbox to installation directory"
    exit 1
fi

# Make binary executable
TOOLBOX_BINARY=$(find ~/.local/share/JetBrains/Toolbox -name "jetbrains-toolbox" -type f)
if [ -z "$TOOLBOX_BINARY" ]; then
    echo "Error: Could not find installed jetbrains-toolbox binary"
    exit 1
fi

chmod +x "$TOOLBOX_BINARY"
echo "✓ Binary made executable: $TOOLBOX_BINARY"

echo "Step 5: Creating symlink..."
# Create symlink if ~/.local/bin is in PATH
if [[ ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
    if ln -sf "$TOOLBOX_BINARY" ~/.local/bin/jetbrains-toolbox; then
        echo "✓ Symlink created: ~/.local/bin/jetbrains-toolbox -> $TOOLBOX_BINARY"
    else
        echo "Warning: Failed to create symlink, but installation can continue"
    fi
else
    echo "Warning: ~/.local/bin is not in PATH, skipping symlink creation"
    echo "You may need to add ~/.local/bin to your PATH or run the full path: $TOOLBOX_BINARY"
fi

echo "Step 6: Starting JetBrains Toolbox..."
echo "This will set up desktop integration (tray icon, application menu, autostart)"

# Test if the binary works before launching
if ! "$TOOLBOX_BINARY" --version >/dev/null 2>&1; then
    echo "Warning: Binary test failed, but attempting to launch anyway..."
fi

# Launch toolbox in background for initial setup
echo "Launching JetBrains Toolbox for initial setup..."
if "$TOOLBOX_BINARY" & then
    TOOLBOX_PID=$!
    echo "✓ JetBrains Toolbox started (PID: $TOOLBOX_PID)"
    
    # Wait a moment for JetBrains Toolbox to attempt its own desktop integration
    sleep 3
    
    # Check if JetBrains Toolbox created its own desktop file
    if [ ! -f ~/.local/share/applications/jetbrains-toolbox.desktop ]; then
        echo "Creating desktop integration manually..."
        
        # Create applications directory if it doesn't exist
        mkdir -p ~/.local/share/applications/
        
        # Find the toolbox icon
        TOOLBOX_ICON="/home/$USER/.local/share/JetBrains/Toolbox/$(basename "$TOOLBOX_BINARY" | cut -d'-' -f1-3)/bin/toolbox-tray-color.png"
        
        # Create desktop file
        cat > ~/.local/share/applications/jetbrains-toolbox.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=JetBrains Toolbox
Comment=Manage your JetBrains IDEs
Exec=$TOOLBOX_BINARY
Icon=$TOOLBOX_ICON
Terminal=false
StartupNotify=true
StartupWMClass=JetBrains Toolbox
Categories=Development;IDE;
Keywords=jetbrains;ide;development;toolbox;
EOF

        # Update desktop database
        if command -v update-desktop-database >/dev/null 2>&1; then
            update-desktop-database ~/.local/share/applications/ 2>/dev/null || true
        fi
        
        echo "✓ Desktop integration created manually"
    else
        echo "✓ JetBrains Toolbox created desktop integration automatically"
    fi
    
    # Fix icon display issues in launcher/dock
    echo "Fixing desktop icon integration..."
    
    # Copy icon to standard location for better launcher integration
    TOOLBOX_ICON_SOURCE="/home/$USER/.local/share/JetBrains/Toolbox/$(basename "$TOOLBOX_BINARY" | cut -d'-' -f1-3)/bin/toolbox-tray-color.png"
    if [ -f "$TOOLBOX_ICON_SOURCE" ]; then
        mkdir -p ~/.local/share/icons/
        cp "$TOOLBOX_ICON_SOURCE" ~/.local/share/icons/jetbrains-toolbox.png
        
        # Update desktop file to use standard icon reference
        sed -i 's|Icon=.*|Icon=jetbrains-toolbox|' ~/.local/share/applications/jetbrains-toolbox.desktop
        
        # Update desktop database
        if command -v update-desktop-database >/dev/null 2>&1; then
            update-desktop-database ~/.local/share/applications/ 2>/dev/null || true
        fi
        
        # Refresh icon cache if available
        if command -v gtk-update-icon-cache >/dev/null 2>&1; then
            gtk-update-icon-cache -f -t ~/.local/share/icons/ 2>/dev/null || true
        fi
        
        echo "✓ Desktop icon integration fixed"
    else
        echo "Warning: Could not find icon file for launcher integration"
    fi
else
    echo "Warning: Failed to start JetBrains Toolbox automatically"
    echo "You can try running it manually: $TOOLBOX_BINARY"
fi

echo ""
echo "=== Installation Complete ==="
echo "JetBrains Toolbox has been installed successfully!"
echo ""
echo "What happens next:"
echo "• JetBrains Toolbox is now running in the background"
echo "• It should appear in your system tray"
echo "• It will be added to your application menu"
echo "• You can find it by searching for 'JetBrains Toolbox'"
echo ""
echo "Usage:"
if command -v jetbrains-toolbox >/dev/null 2>&1; then
    echo "• Run 'jetbrains-toolbox' from terminal"
else
    echo "• Run '$TOOLBOX_BINARY' from terminal"
fi
echo "• Or find 'JetBrains Toolbox' in your application menu"
echo "• Use the Toolbox to install JetBrains IDEs (IntelliJ, PyCharm, etc.)" 