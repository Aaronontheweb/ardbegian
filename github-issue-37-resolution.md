# Resolution: Switched to Default Zellij Configuration

After thorough investigation, I've determined that this issue stems from Omakub's highly customized Zellij configuration, which uses a modal interface and overrides standard terminal keybindings.

## The Problem

Omakub's Zellij configuration:
- Uses `keybinds clear-defaults=true` to remove all default keybindings
- Binds `Ctrl+C` to various Zellij navigation commands
- Implements a "locked by default" modal interface

This prevents `Ctrl+C` from sending the interrupt signal (SIGINT) to child processes.

## The Solution

I've updated Ardbegian to use Zellij's default configuration instead. This provides:
- ✅ Working `Ctrl+C` for interrupting processes
- ✅ Standard keybindings that most developers expect
- ✅ No modal confusion
- ✅ Better community support and documentation

## Changes Made

1. **Updated installer** (`install/terminal/app-zellij.sh`): Now generates default Zellij config instead of copying Omakub's
2. **Added migration** (`migrations/1753412630.sh`): Automatically migrates existing users to default config while preserving themes
3. **Added documentation** (`docs/zellij-changes.md`): Explains the change and provides keybinding reference

## For Users

- **New installations**: Will get the default Zellij config automatically
- **Existing users**: Migration will run automatically on next update
- **Vim/Neovim users**: Can restore the modal config from the automatic backup if preferred

The default Zellij keybindings are intuitive and well-documented. Most importantly, `Ctrl+C` now works as expected for interrupting processes.

Closing this issue as resolved. The fix is implemented in the Ardbegian fork.