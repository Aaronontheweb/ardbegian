#!/bin/bash

# Function to log warnings (inherited from parent script)
if ! declare -F log_warning > /dev/null; then
    log_warning() {
        local message=$1
        echo "⚠️  $message"
    }
fi

if [ ! -f /etc/os-release ]; then
  log_warning "Unable to determine OS. /etc/os-release file not found."
  log_warning "Installation will continue but may fail later."
  return 1
fi

. /etc/os-release

# Check if running on Ubuntu 24.04 or higher
if [ "$ID" != "ubuntu" ] || [ $(echo "$VERSION_ID >= 24.04" | bc 2>/dev/null || echo "0") != 1 ]; then
  log_warning "OS requirement not met"
  log_warning "You are currently running: $ID $VERSION_ID"
  log_warning "OS required: Ubuntu 24.04 or higher"
  log_warning "Installation will continue but may fail later."
  return 1
fi

# Check if running on x86
ARCH=$(uname -m)
if [ "$ARCH" != "x86_64" ] && [ "$ARCH" != "i686" ]; then
  log_warning "Unsupported architecture detected"
  log_warning "Current architecture: $ARCH"
  log_warning "This installation is only supported on x86 architectures (x86_64 or i686)."
  log_warning "Installation will continue but may fail later."
  return 1
fi

echo "✅ System compatibility check passed"
