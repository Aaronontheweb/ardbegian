#!/bin/bash

# Remove JetBrains Toolbox installation
echo "Removing JetBrains Toolbox..."

# Remove the main installation directory
rm -rf ~/.local/share/JetBrains/Toolbox

# Remove symlink if it exists
rm -f ~/.local/bin/jetbrains-toolbox

# Remove desktop entry if it exists
rm -f ~/.local/share/applications/jetbrains-toolbox.desktop

# Remove autostart entry if it exists
rm -f ~/.config/autostart/jetbrains-toolbox.desktop

echo "JetBrains Toolbox uninstalled successfully!" 
echo "Note: Individual IDE installations and user data are preserved."
echo "To remove all JetBrains data, run:"
echo "  rm -rf ~/.local/share/JetBrains"
echo "  rm -rf ~/.config/JetBrains" 