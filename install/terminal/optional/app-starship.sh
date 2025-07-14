#!/bin/bash

# Install Starship prompt
curl -sS https://starship.rs/install.sh | sh

# Create Starship configuration directory
mkdir -p ~/.config

# Create a minimal Starship config that works well with Zellij
cat > ~/.config/starship.toml << 'EOF'
# Get editor completions based on the config schema
"$schema" = 'https://starship.rs/config-schema.json'

# Inserts a blank line between shell prompts
add_newline = true

# Replace the '❯' symbol in the prompt with '➜'
[character]
success_symbol = '[➜](bold green)'
error_symbol = '[✗](bold red)'

# Disable the package module, hiding it from the prompt completely
[package]
disabled = true

# Customize the git status module
[git_status]
conflicted = "⚡"
ahead = "⇡\${count}"
behind = "⇣\${count}"
diverged = "⇕⇡\${ahead_count}⇣\${behind_count}"
untracked = "?"
stashed = "≡"
modified = "!"
staged = "+"
renamed = "»"
deleted = "✘"

# Customize the git_branch module
[git_branch]
symbol = " "
truncation_length = 4
truncation_symbol = ""
style = "bold purple"

# Customize the directory module
[directory]
truncation_length = 3
truncation_symbol = "…/"
style = "bold blue"

# Customize the hostname module
[hostname]
ssh_only = true
disabled = false
truncation_length = 0
truncation_symbol = ""
style = "bold green"

# Customize the username module
[username]
style_user = "bold yellow"
style_root = "bold red"
disabled = false
show_always = true
EOF

echo "Starship installed and configured!"
echo "To use Starship, add this line to your ~/.bashrc:"
echo "eval \"\$(starship init bash)\"" 