# Uninstall DaVinci Resolve
echo "🗑️  Uninstalling DaVinci Resolve..."

# Check if DaVinci Resolve is installed
if [ ! -d "/opt/resolve" ]; then
    echo "❌ DaVinci Resolve is not installed"
    exit 1
fi

echo "This will remove DaVinci Resolve from your system."
echo ""
echo "⚠️  USER DATA PRESERVATION:"
echo "   • Your projects and databases will be preserved in:"
echo "     ~/.local/share/DaVinciResolve/"
echo "   • Media files and project exports are not affected"
echo ""

gum confirm "Continue with uninstallation?" || exit 1

# Stop DaVinci Resolve if it's running
echo "🛑 Stopping DaVinci Resolve processes..."
pkill -f "resolve" 2>/dev/null || true
pkill -f "DaVinciResolve" 2>/dev/null || true

# Wait a moment for processes to stop
sleep 2

echo "📁 Removing DaVinci Resolve installation..."

# Remove the main installation directory
sudo rm -rf /opt/resolve

# Remove desktop entry
sudo rm -f /usr/share/applications/davinci-resolve.desktop

# Remove any symlinks
sudo rm -f /usr/local/bin/resolve

# Update desktop database
sudo update-desktop-database

echo ""
echo "✅ DaVinci Resolve has been uninstalled successfully!"
echo ""
echo "📋 What was preserved:"
echo "   • User projects: ~/.local/share/DaVinciResolve/"
echo "   • System packages that were installed as dependencies"
echo ""
echo "💡 To completely remove user data (optional):"
echo "   rm -rf ~/.local/share/DaVinciResolve/"
echo "" 