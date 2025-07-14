wget -qO- https://discord.com/api/downloads/distro/app/stream/x86_64 -O /tmp/discord.deb
sudo dpkg -i /tmp/discord.deb
sudo apt-get install -f -y
rm /tmp/discord.deb 