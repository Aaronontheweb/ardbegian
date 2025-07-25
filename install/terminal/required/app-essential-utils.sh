# Install essential utilities that are commonly missing and cause failures
echo "Installing essential utilities..."

# Install bc (used for version comparison)
if ! command -v bc &> /dev/null; then
    sudo apt install -y bc
fi

# Install dmidecode (used for hardware detection)
if ! command -v dmidecode &> /dev/null; then
    sudo apt install -y dmidecode
fi

# Install wget (used for downloads)
if ! command -v wget &> /dev/null; then
    sudo apt install -y wget
fi

# Install curl (used for downloads)
if ! command -v curl &> /dev/null; then
    sudo apt install -y curl
fi

# Install unzip (used for extracting packages)
if ! command -v unzip &> /dev/null; then
    sudo apt install -y unzip
fi

# Install git (used for various installations)
if ! command -v git &> /dev/null; then
    sudo apt install -y git
fi

# Install snapd (used for snap package installations)
if ! command -v snap &> /dev/null; then
    sudo apt install -y snapd
fi

echo "Essential utilities installed" 