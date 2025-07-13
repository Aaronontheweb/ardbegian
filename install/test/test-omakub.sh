#!/usr/bin/env bash
set -euo pipefail

# ---------- CLI flags ----------
REPO=
BRANCH=main
VM_NAME=omakub-test
PASSWD=omakub

while [[ $# -gt 0 ]]; do
  case $1 in
    --repo)   REPO="$2"; shift 2;;
    --branch) BRANCH="$2"; shift 2;;
    --vm)     VM_NAME="$2"; shift 2;;
    --passwd) PASSWD="$2"; shift 2;;
    *) echo "Unknown flag $1"; exit 1;;
  esac
done

[[ -z "$REPO" ]] && { echo "❌  --repo is required"; exit 1; }

# ---------- cloud-init ----------
TMP=$(mktemp -d)
CLOUD="$TMP/cloud-init.yaml"

cat >"$CLOUD" <<EOF
#cloud-config
ssh_pwauth: true
users:
  - default
chpasswd:
  list: |
    ubuntu:${PASSWD}
  expire: false

package_update: true
packages:
  - git
  - curl
  - ubuntu-desktop-minimal
  - gnome-shell-extension-manager
  - xrdp

runcmd:
  - systemctl enable xrdp
  - systemctl restart xrdp
  - su - ubuntu -c "git clone ${REPO} repo"
  - su - ubuntu -c "cd repo && git switch ${BRANCH} || git checkout -b ${BRANCH} origin/${BRANCH}"
EOF

# ---------- launch VM ----------
echo "▶ Launching VM '${VM_NAME}' …"
multipass launch 24.04 \
  --name  "${VM_NAME}" \
  --cpus  4             \
  --mem   8G            \
  --disk  25G           \
  --cloud-init "$CLOUD"

IP=$(multipass info "$VM_NAME" | awk '/IPv4/ {print $2}')

cat <<EOS

🎉  VM booting.  When ready, RDP in:

    Host : $IP
    User : ubuntu
    Pass : $PASSWD

    Example:
        remmina "rdp://${IP}"

💡  Inside the session run:

        cd ~/repo
        ./install.sh

     …and step through every prompt interactively.

🔁  To start over:
        multipass delete ${VM_NAME} && multipass purge
        ./test-omakub.sh --repo $REPO --branch $BRANCH --vm ${VM_NAME}

EOS
