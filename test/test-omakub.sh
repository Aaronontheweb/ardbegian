#!/usr/bin/env bash
set -euo pipefail

# ── CLI flags ──────────────────────────────────────────────────────────────
REPO_RAW=https://raw.githubusercontent.com/Aaronontheweb/ardbegian/master/boot.sh
VM_NAME=omakub-test
PASSWD=omakub     # password for "ubuntu" (RDP)

while [[ $# -gt 0 ]]; do
  case $1 in
    --vm)     VM_NAME="$2"; shift 2 ;;
    --passwd) PASSWD="$2"; shift 2 ;;
    *) echo "Unknown flag $1"; exit 1 ;;
  esac
done

# ── LAUNCH VM, pass user-data on stdin ─────────────────────────────────────
echo "▶ Launching VM '${VM_NAME}' …"

multipass launch 24.04 \
  --name    "${VM_NAME}" \
  --cpus    4            \
  --memory  8G           \
  --disk    25G          \
  --cloud-init - <<EOF
#cloud-config
ssh_pwauth: true

# Set password for the default ubuntu user
chpasswd:
  list: |
    ubuntu:${PASSWD}
  expire: false

bootcmd:
  # point resolved at Cloudflare + Google (edit to taste)
  - printf '[Resolve]\nDNS=1.1.1.1 8.8.8.8\nDNSStubListener=no\n' > /etc/systemd/resolved.conf
  - [ systemctl, restart, systemd-resolved ]

package_update: true
packages:
  - curl
  - git
  - bc                    # Required for version comparison in check-version.sh
  - ubuntu-desktop
  - gnome-shell-extension-manager
  - wget                  # Required for mise installation
  - gpg                   # Required for mise installation

runcmd:
  # Configure GNOME built-in Remote Desktop for RDP (as ubuntu user)
  - [ bash, -c, "su - ubuntu -c 'gsettings set org.gnome.desktop.remote-desktop.rdp enable true'" ]
  - [ bash, -c, "su - ubuntu -c 'gsettings set org.gnome.desktop.remote-desktop.rdp view-only false'" ]
  - [ bash, -c, "su - ubuntu -c 'gsettings set org.gnome.desktop.remote-desktop.rdp enable-credentials-prompt false'" ]
  - [ bash, -c, "su - ubuntu -c 'gsettings set org.gnome.desktop.remote-desktop.rdp authentication-methods \"[\\'password\\']\"'" ]
  - [ bash, -c, "su - ubuntu -c 'gsettings set org.gnome.desktop.remote-desktop.rdp password \"${PASSWD}\"'" ]
  # Ensure XDG_CURRENT_DESKTOP is set for Omakub installation
  - [ bash, -c, "echo 'export XDG_CURRENT_DESKTOP=GNOME' >> /home/ubuntu/.bashrc" ]
  - [ bash, -c, "su - ubuntu -c 'export OMAKUB_AUTOMATED_TEST=true && export XDG_CURRENT_DESKTOP=GNOME && curl -fsSL ${REPO_RAW} -o ~/boot.sh'" ]
  - [ bash, -c, "su - ubuntu -c 'export OMAKUB_AUTOMATED_TEST=true && export XDG_CURRENT_DESKTOP=GNOME && chmod +x ~/boot.sh && ~/boot.sh'" ]
EOF

# ── PRINT RDP INFO ─────────────────────────────────────────────────────────
IP=$(multipass info "$VM_NAME" | awk '/IPv4/ {print $2}')

cat <<EOS

🎉  VM is booting.  When it's ready, connect via RDP:

    Host : $IP
    User : ubuntu
    Pass : $PASSWD

The fetched 'boot.sh' script will finish cloning & setup automatically.

To reset:

    multipass delete ${VM_NAME} && multipass purge
    ./test-omakub.sh --vm ${VM_NAME}

EOS
