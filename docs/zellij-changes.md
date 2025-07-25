# Zellij Configuration Changes in Ardbegian

## Why We Changed from Omakub's Configuration

Omakub uses a highly customized Zellij configuration with a modal interface (similar to Vim). While this works well for heavy Vim/Neovim users, it causes several issues for general terminal usage:

### The Main Issue: Ctrl+C Doesn't Work

In Omakub's configuration, `Ctrl+C` is bound to Zellij commands instead of sending the interrupt signal (SIGINT) to running processes. This means you can't:
- Stop running servers (`npm run dev`, `rails server`, etc.)
- Interrupt long-running commands
- Cancel operations in the terminal

### Other Issues

- **Confusing modal interface**: You need to press `Ctrl+G` to switch between "locked" and "normal" modes
- **Non-standard keybindings**: Many common terminal operations work differently
- **Steep learning curve**: The configuration assumes familiarity with modal editors

## What We Changed

Ardbegian now uses Zellij's default configuration, which:
- ✅ **Ctrl+C works normally** for interrupting processes
- ✅ Uses standard keybindings that most users expect
- ✅ No modal confusion - commands are always available
- ✅ Better documented and supported by the Zellij community

## Default Zellij Keybindings

Here are the most common keybindings in the default configuration:

- `Ctrl+p` → Pane mode (manage panes)
- `Ctrl+t` → Tab mode (manage tabs)
- `Ctrl+n` → Resize mode
- `Ctrl+s` → Scroll mode
- `Ctrl+o` → Session mode
- `Ctrl+q` → Quit Zellij
- `Alt+n` → New pane
- `Alt+h/j/k/l` or `Alt+arrow` → Navigate between panes

## For Existing Users

If you're upgrading from Omakub, the migration script will automatically:
1. Backup your old configuration
2. Generate the default Zellij configuration
3. Preserve your theme settings

Your old configuration is saved with a timestamp, so you can restore it if needed:
```bash
# To restore the old Omakub configuration:
mv ~/.config/zellij/config.kdl.omakub-backup-[timestamp] ~/.config/zellij/config.kdl
```

## For Vim/Neovim Users

If you prefer the modal interface and are comfortable with the Ctrl+C limitation, you can still use Omakub's configuration by copying it from the backup or from the original Omakub repository.