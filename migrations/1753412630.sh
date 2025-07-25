#!/bin/bash

# Migration: Switch from Omakub's custom Zellij config to default config
# This fixes the Ctrl+C issue and provides a more standard experience

ZELLIJ_CONFIG="$HOME/.config/zellij/config.kdl"

# Check if user has the Omakub Zellij config
if [ -f "$ZELLIJ_CONFIG" ] && grep -q "keybinds clear-defaults=true" "$ZELLIJ_CONFIG" 2>/dev/null; then
    echo "Migrating to default Zellij configuration..."
    
    # Backup the old config
    cp "$ZELLIJ_CONFIG" "$ZELLIJ_CONFIG.omakub-backup-$(date +%Y%m%d)"
    
    # Generate new default config
    zellij setup --dump-config > "$ZELLIJ_CONFIG.tmp"
    
    # Check if the old config had a custom theme
    OLD_THEME=$(grep -E "^theme" "$ZELLIJ_CONFIG" | grep -v "//" | head -1)
    if [ -n "$OLD_THEME" ]; then
        # Append the theme to the new config
        echo "" >> "$ZELLIJ_CONFIG.tmp"
        echo "// Theme configuration (preserved from previous config)" >> "$ZELLIJ_CONFIG.tmp"
        echo "$OLD_THEME" >> "$ZELLIJ_CONFIG.tmp"
    fi
    
    # Replace the config
    mv "$ZELLIJ_CONFIG.tmp" "$ZELLIJ_CONFIG"
    
    echo "✅ Zellij configuration migrated successfully!"
    echo "   - Your old config is backed up as: $ZELLIJ_CONFIG.omakub-backup-$(date +%Y%m%d)"
    echo "   - Ctrl+C now works properly for interrupting processes"
    echo "   - Default keybindings are now active"
else
    echo "No Zellij migration needed - config is already using defaults or doesn't exist"
fi