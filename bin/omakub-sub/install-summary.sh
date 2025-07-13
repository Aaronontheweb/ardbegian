#!/bin/bash

LOG_DIR="$HOME/.local/share/omakub/logs"

if [ ! -d "$LOG_DIR" ]; then
    echo "No installation logs found."
    exit 1
fi

# Find the most recent log file
LATEST_LOG=$(ls -t "$LOG_DIR"/install-*.log 2>/dev/null | head -n 1)

if [ -z "$LATEST_LOG" ]; then
    echo "No installation log files found in $LOG_DIR"
    exit 1
fi

echo "📋 Installation Summary from: $(basename "$LATEST_LOG")"
echo "=================================================="

# Show errors
echo ""
echo "❌ Errors:"
if grep -q "ERROR:" "$LATEST_LOG"; then
    grep "ERROR:" "$LATEST_LOG" | tail -10
else
    echo "No errors found"
fi

# Show warnings
echo ""
echo "⚠️  Warnings:"
if grep -q "WARNING:" "$LATEST_LOG"; then
    grep "WARNING:" "$LATEST_LOG" | tail -10
else
    echo "No warnings found"
fi

# Show completion status
echo ""
echo "📊 Status:"
if grep -q "Omakub installation completed" "$LATEST_LOG"; then
    echo "✅ Installation completed successfully"
else
    echo "❌ Installation did not complete"
fi

echo ""
echo "📄 Full log available at: $LATEST_LOG" 