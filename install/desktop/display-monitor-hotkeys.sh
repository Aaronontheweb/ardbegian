#!/usr/bin/env sh

# Install helper command to switch to main-monitor-only configuration
sudo tee /usr/local/bin/display-main-only >/dev/null <<'EOL'
#!/usr/bin/env bash
set -e

# Prefer autorandr profile if available
if command -v autorandr >/dev/null 2>&1; then
  autorandr --change --profile main && exit 0
fi

SESSION_TYPE="${XDG_SESSION_TYPE:-x11}"

if [ "$SESSION_TYPE" = "wayland" ]; then
  # TODO: implement Wayland DBus call; fallback exits silently for now
  exit 0
else
  primary=$(xrandr --query | awk '/ connected primary/{print $1}')
  if [ -n "$primary" ]; then
    xrandr --output "$primary" --auto --primary
    for output in $(xrandr --query | awk '/ connected/{print $1}' | grep -v "$primary"); do
      xrandr --output "$output" --off
    done
  fi
fi
EOL

sudo chmod +x /usr/local/bin/display-main-only

# Install helper command to restore joined-monitor configuration
sudo tee /usr/local/bin/display-joined >/dev/null <<'EOL'
#!/usr/bin/env bash
set -e

if command -v autorandr >/dev/null 2>&1; then
  autorandr --change --profile joined && exit 0
fi

SESSION_TYPE="${XDG_SESSION_TYPE:-x11}"

if [ "$SESSION_TYPE" != "wayland" ]; then
  primary=$(xrandr --query | awk '/ connected primary/{print $1}')
  xrandr --output "$primary" --auto --primary
  for output in $(xrandr --query | awk '/ connected/{print $1}' | grep -v "$primary"); do
    xrandr --output "$output" --auto
  done
fi
EOL

sudo chmod +x /usr/local/bin/display-joined 