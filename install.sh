# Exit immediately if a command exits with a non-zero status
set -e

# Create log directory and file
LOG_DIR="$HOME/.local/share/omakub/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/install-$(date +%Y%m%d-%H%M%S).log"

# Function to log errors and continue
log_error() {
    local exit_code=$?
    local line_number=$1
    local command=$2
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: Command failed at line $line_number: $command (exit code: $exit_code)" >> "$LOG_FILE"
    echo "⚠️  Command failed: $command (logged to $LOG_FILE)"
    echo "Continuing with installation..."
    return 0  # Prevent exit
}

# Function to log warnings
log_warning() {
    local message=$1
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] WARNING: $message" >> "$LOG_FILE"
    echo "⚠️  $message"
}

# Enhanced error trap that logs and continues
trap 'log_error ${LINENO} "$BASH_COMMAND"' ERR

# Function to run commands with error handling
run_safe() {
    local description=$1
    shift
    echo "🔄 $description..."
    if "$@"; then
        echo "✅ $description completed"
    else
        log_warning "$description failed, but continuing..."
    fi
}

# Log installation start
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting Omakub installation" >> "$LOG_FILE"
echo "🚀 Starting Omakub installation..."
echo "📝 Logging to: $LOG_FILE"

# Install essential utilities first
run_safe "Installing essential utilities" source ~/.local/share/omakub/install/terminal/required/app-essential-utils.sh

# Check the distribution name and version and abort if incompatible
run_safe "Checking system compatibility" source ~/.local/share/omakub/install/check-version.sh

# Ask for app choices
echo "Get ready to make a few choices..."
run_safe "Installing gum" source ~/.local/share/omakub/install/terminal/required/app-gum.sh >/dev/null
run_safe "Collecting app choices" source ~/.local/share/omakub/install/first-run-choices.sh
run_safe "Collecting user identification" source ~/.local/share/omakub/install/identification.sh

# Desktop software and tweaks will only be installed if we're running Gnome
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
  # Ensure computer doesn't go to sleep or lock while installing
  run_safe "Configuring power settings" gsettings set org.gnome.desktop.screensaver lock-enabled false
  run_safe "Configuring idle delay" gsettings set org.gnome.desktop.session idle-delay 0

  echo "Installing terminal and desktop tools..."

  # Install terminal tools
  run_safe "Installing terminal tools" source ~/.local/share/omakub/install/terminal.sh

  # Install desktop tools and tweaks
  run_safe "Installing desktop tools" source ~/.local/share/omakub/install/desktop.sh

  # Revert to normal idle and lock settings
  run_safe "Restoring power settings" gsettings set org.gnome.desktop.screensaver lock-enabled true
  run_safe "Restoring idle delay" gsettings set org.gnome.desktop.session idle-delay 300
else
  echo "Only installing terminal tools..."
  run_safe "Installing terminal tools" source ~/.local/share/omakub/install/terminal.sh
fi

# Log installation completion
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Omakub installation completed" >> "$LOG_FILE"
echo "🎉 Omakub installation completed!"
echo "📋 Check the log file for any issues: $LOG_FILE"
