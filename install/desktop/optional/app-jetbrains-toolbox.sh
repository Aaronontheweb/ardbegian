#!/bin/bash

# Download and install JetBrains Toolbox
cd /tmp

# Download the latest JetBrains Toolbox App
wget -O jetbrains-toolbox.tar.gz "https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.28.1.15219.tar.gz"

# Extract the archive
tar -xzf jetbrains-toolbox.tar.gz

# Move to /opt for system-wide installation
sudo mv jetbrains-toolbox-* /opt/jetbrains-toolbox

# Make it executable
sudo chmod +x /opt/jetbrains-toolbox/jetbrains-toolbox

# Clean up
rm -f jetbrains-toolbox.tar.gz
cd -

echo "JetBrains Toolbox installed successfully!"
echo "You can now install JetBrains Rider and other IDEs through the Toolbox." 