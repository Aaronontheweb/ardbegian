cat <<EOF >~/.local/share/applications/Discord.desktop
[Desktop Entry]
Version=1.0
Name=Discord
Comment=Discord for Linux
Exec=/usr/bin/discord
Terminal=false
Type=Application
Icon=/home/$USER/.local/share/omakub/applications/icons/Discord.png
Categories=GTK;Network;InstantMessaging;
MimeType=text/html;text/xml;application/xhtml_xml;
StartupNotify=true
EOF 