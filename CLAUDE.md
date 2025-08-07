# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is Omakub (ardbegian fork) - a setup automation system that transforms fresh Ubuntu 24.04+ installations into fully-configured development environments. The project consists of shell scripts organized into modular components for installing and configuring various development tools, desktop applications, and system settings.

## Repository Structure

- **install/** - Main installation scripts organized by category:
  - **desktop/** - GUI applications (VS Code, Brave, Discord, etc.)
  - **terminal/** - CLI tools (Neovim, Docker, Lazygit, etc.)
  - **desktop/optional/** and **terminal/optional/** - Additional tools users can select
- **themes/** - Color scheme configurations for various tools (Alacritty, Neovim, VS Code, etc.)
- **configs/** - Configuration templates for installed applications
- **defaults/** - Default bash configurations
- **migrations/** - Scripts for updating existing installations
- **uninstall/** - Scripts to remove installed applications

## Key Scripts

- **boot.sh** - Initial bootstrap script that clones the repository
- **install.sh** - Main installation orchestrator with error handling and logging
- **install/first-run-choices.sh** - Interactive selection of optional applications
- **install/check-version.sh** - Verifies Ubuntu version compatibility

## Testing

Local testing uses Multipass VMs:

```bash
./test/test-omakub.sh --vm omakub-test --passwd omakub
```

Wait for cloud-init to complete:
```bash
multipass shell omakub-test
cloud-init status --wait
```

Connect via RDP to test the desktop installation.

Cleanup:
```bash
multipass delete omakub-test
multipass purge
```

## Development Workflow

1. All scripts should use `set -e` for error handling
2. Installation scripts log to `~/.local/share/omakub/logs/`
3. Scripts are modular - each application has its own installation script
4. Desktop installations only run in GNOME environments
5. Version compatibility checks occur before installation

## Architecture Principles

- **Modular Design**: Each application/tool has dedicated install/uninstall scripts
- **Theme System**: Centralized theme configurations that apply across multiple tools
- **Error Resilience**: The main installer uses error trapping and logging to continue despite individual failures
- **User Choice**: Interactive selection via gum for optional components
- **Environment Detection**: Automatically detects GNOME desktop vs terminal-only environments