wget -qO- https://downloads.slack-edge.com/releases/linux/64/deb/slack-desktop-4.0.2-amd64.deb -O /tmp/slack-desktop.deb
sudo dpkg -i /tmp/slack-desktop.deb
sudo apt-get install -f -y
rm /tmp/slack-desktop.deb 