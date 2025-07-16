# DaVinci Resolve is professional video editing, color grading and visual effects software
echo "🎬 Installing DaVinci Resolve..."

# Check system requirements
echo "Checking system requirements..."

# Minimum 16GB RAM check (32GB recommended for Linux)
total_ram_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
total_ram_gb=$((total_ram_kb / 1024 / 1024))

if [ $total_ram_gb -lt 16 ]; then
    echo "⚠️  Warning: DaVinci Resolve requires at least 16GB RAM (32GB recommended)"
    echo "   Your system has ${total_ram_gb}GB RAM"
    gum confirm "Continue installation anyway?" || exit 1
fi

# Check for discrete GPU
if ! lspci | grep -E "(VGA|3D)" | grep -E "(NVIDIA|AMD)" > /dev/null; then
    echo "⚠️  Warning: DaVinci Resolve requires a discrete GPU (NVIDIA/AMD)"
    echo "   Integrated graphics may not provide adequate performance"
    gum confirm "Continue installation anyway?" || exit 1
fi

# Check if already installed
if [ -d "/opt/resolve" ]; then
    echo "✅ DaVinci Resolve appears to already be installed"
    gum confirm "Reinstall anyway?" || exit 0
fi

# Check if DaVinci Resolve has been downloaded
echo ""
echo "📥 DaVinci Resolve Download Required"
echo ""
echo "Due to registration requirements, you must manually download DaVinci Resolve:"
echo ""
echo "   1. Visit: https://www.blackmagicdesign.com/support/family/davinci-resolve-and-fusion"
echo "   2. Fill out the form and download 'DaVinci Resolve 20.x Linux'"
echo "   3. Save the .zip file to your Downloads folder"
echo ""

# Check if file exists in Downloads
RESOLVE_ZIP=$(find ~/Downloads -name "DaVinci_Resolve_*_Linux.zip" 2>/dev/null | head -1)

if [ -z "$RESOLVE_ZIP" ]; then
    echo "❌ DaVinci Resolve not found in Downloads folder"
    echo "   Please download it first, then run this installer again"
    exit 1
fi

echo "✅ Found: $(basename "$RESOLVE_ZIP")"
gum confirm "Install DaVinci Resolve now?" || exit 0

# Create temporary directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo "📦 Extracting installer..."
unzip -q "$RESOLVE_ZIP"

# Find the .run installer
RESOLVE_RUN=$(find . -name "DaVinci_Resolve_*_Linux.run" | head -1)

if [ -z "$RESOLVE_RUN" ]; then
    echo "❌ Could not find .run installer in the zip file"
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo "🔧 Installing system dependencies..."
sudo apt update
sudo apt install -y \
    libqt5x11extras5 \
    libapr1 \
    libaprutil1 \
    libaprutil1-dbd-sqlite3 \
    libaprutil1-ldap \
    libxcb-composite0 \
    libxcb-cursor0 \
    libxcb-damage0 \
    libxcb-xinerama0 \
    libxcb-xinput0 \
    libglu1-mesa \
    ocl-icd-opencl-dev \
    opencl-headers \
    clinfo

# Ensure en_US.UTF-8 locale is available (DaVinci Resolve requirement)
echo "🌐 Setting up locale..."
if ! locale -a | grep -q "en_US.utf8"; then
    sudo apt install -y locales
    sudo locale-gen en_US.UTF-8
fi

echo "🚀 Running DaVinci Resolve installer..."
echo "   This may take a few minutes and will require sudo password..."

# Make installer executable and run it
chmod +x "$RESOLVE_RUN"

# Run the installer with skip package check to avoid Ubuntu compatibility issues
sudo SKIP_PACKAGE_CHECK=1 "$RESOLVE_RUN" -i

# Check if installation was successful
if [ ! -d "/opt/resolve" ]; then
    echo "❌ Installation appears to have failed"
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo "🔧 Applying Ubuntu 24.04 compatibility fixes..."

# Install older OpenSSL 1.1 libraries required by DaVinci Resolve
echo "📦 Installing OpenSSL 1.1 libraries..."
wget -q http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.24_amd64.deb
sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2.24_amd64.deb
rm libssl1.1_1.1.1f-1ubuntu2.24_amd64.deb

# Move conflicting glib-related libraries that cause symbol lookup errors
if [ -d "/opt/resolve/libs" ]; then
    cd "/opt/resolve/libs"
    
    echo "🔧 Moving conflicting libraries to use Ubuntu 24.04 system versions..."
    sudo mkdir -p disabled_libs
    
    # Move the specific libraries that cause conflicts with Ubuntu 24.04
    sudo mv libglib-2.0.so* libgio-2.0.so* libgmodule-2.0.so* disabled_libs/ 2>/dev/null || true
fi

# Note: DaVinci Resolve installer automatically creates desktop entries
echo "🖥️  Desktop entries created automatically by installer"

# Fix desktop entry to show icon properly in launcher when running
echo "🔧 Fixing desktop entry for proper launcher integration..."
mkdir -p ~/.local/share/applications/

# Create a fixed version of the desktop entry with StartupWMClass
cat > ~/.local/share/applications/com.blackmagicdesign.resolve.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=DaVinci Resolve
GenericName=DaVinci Resolve
Comment=Revolutionary new tools for editing, visual effects, color correction and professional audio post production, all in a single application!
Path=/opt/resolve/
Exec=/opt/resolve/bin/resolve %u
Terminal=false
MimeType=application/x-resolveproj;
Icon=/opt/resolve/graphics/DV_Resolve.png
StartupNotify=true
StartupWMClass=resolve
Name[en_US]=DaVinci Resolve
EOF

# Update desktop database
if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database ~/.local/share/applications/ 2>/dev/null || true
fi

echo "✓ Desktop entry fixed for proper launcher integration"

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "✅ DaVinci Resolve installation completed!"
echo ""
echo "🎯 Important Notes:"
echo "   • Find DaVinci Resolve in your applications menu"
echo "   • Icon will now properly show in launcher when app is running"
echo "   • For NVIDIA users: Make sure you have proprietary drivers installed"
echo "   • For AMD users: Make sure you have ROCm or AMDGPU-PRO drivers"
echo "   • First launch may take a while to initialize"
echo ""
echo "🚀 You can now start creating professional video content!" 