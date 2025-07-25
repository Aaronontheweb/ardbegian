cd /tmp
wget -O zellij.tar.gz "https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz"
tar -xf zellij.tar.gz zellij
sudo install zellij /usr/local/bin
rm zellij.tar.gz zellij
cd -

mkdir -p ~/.config/zellij/themes

# Generate default Zellij config instead of using Omakub's custom one
if [ ! -f "$HOME/.config/zellij/config.kdl" ]; then
    zellij setup --dump-config > ~/.config/zellij/config.kdl
    # Add theme configuration to the default config
    echo "" >> ~/.config/zellij/config.kdl
    echo "// Theme configuration" >> ~/.config/zellij/config.kdl
    echo "theme \"tokyo-night\"" >> ~/.config/zellij/config.kdl
fi

# Still copy the theme file
cp ~/.local/share/omakub/themes/tokyo-night/zellij.kdl ~/.config/zellij/themes/tokyo-night.kdl
