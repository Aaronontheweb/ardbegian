# Install Sublime Text 3
cd /tmp

# Download and install the GPG key
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null

# Add the repository
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# Update package list and install Sublime Text
sudo apt update -y
sudo apt install -y sublime-text

cd - 