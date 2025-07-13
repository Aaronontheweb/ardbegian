#!/usr/bin/env bash
set -e

ascii_art='________                  __        ___.
\_____  \   _____ _____  |  | ____ _\_ |__
 /   |   \ /     \\__   \ |  |/ /  |  \ __ \
/    |    \  Y Y  \/ __ \|    <|  |  / \_\ \
\_______  /__|_|  (____  /__|_ \____/|___  /
        \/      \/     \/     \/         \/
'

echo -e "$ascii_art"
echo "=> Omakub is for fresh Ubuntu 24.04+ installations only!"
echo -e "\nBegin installation (or abort with Ctrl+C)…"

# Make sure Git is present
sudo apt-get update -qq
sudo apt-get install -y git -qq

echo "Cloning Omakub (master branch)…"
rm -rf ~/.local/share/omakub
git clone --depth 1 --branch master \
  https://github.com/Aaronontheweb/ardbegian.git \
  ~/.local/share/omakub >/dev/null

echo -e "\nWhen you’re ready to install, run:"
echo "  source ~/.local/share/omakub/install.sh"
