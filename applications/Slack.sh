cat <<EOF >~/.local/share/applications/Slack.desktop
[Desktop Entry]
Version=1.0
Name=Slack
Comment=Slack for Linux
Exec=/usr/bin/slack
Terminal=false
Type=Application
Icon=/home/$USER/.local/share/omakub/applications/icons/Slack.png
Categories=GTK;Network;InstantMessaging;
MimeType=text/html;text/xml;application/xhtml_xml;
StartupNotify=true
EOF 