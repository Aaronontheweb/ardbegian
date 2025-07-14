# Oh My Bash Customization Guide

## Directory Display Options

After installing Oh My Bash, you can customize how directories are displayed by editing `~/.bashrc` and modifying the `prompt_dir()` function.

### Current Default: `%~`
Shows the current directory with home directory as `~` and truncates long paths:
```
~/repositories/ardbegian
```

### Option 1: Full Absolute Path
Change `dir_display='%~'` to `dir_display='$(pwd)'`:
```
/home/aaronontheweb/repositories/ardbegian
```

### Option 2: Current Directory Only
Change `dir_display='%~'` to `dir_display='$(basename $(pwd))'`:
```
ardbegian
```

### Option 3: Full Path with ~ for Home
Change `dir_display='%~'` to `dir_display='$(pwd | sed "s|$HOME|~|")'`:
```
~/repositories/ardbegian
```

## Git Status Indicators

The Agnoster theme shows git information automatically:
- `(branch-name)` - Current branch
- `●` - Uncommitted changes
- `↑` - Ahead of remote
- `↓` - Behind remote
- `⇅` - Diverged from remote
- `+` - Staged changes
- `!` - Modified files
- `?` - Untracked files

## Theme Options

You can change themes by modifying `OSH_THEME` in `~/.bashrc`:

Popular themes:
- `agnoster` - Full-featured with git info (default)
- `robbyrussell` - Simple and clean
- `agnoster-custom` - Customizable version of agnoster
- `powerline` - Powerline-style prompt
- `powerline-multiline` - Multi-line powerline

## Plugin Management

Enable/disable plugins by editing the `plugins=()` array in `~/.bashrc`:

```bash
plugins=(
  git          # Git integration
  bashmarks    # Directory bookmarks
  docker       # Docker completions
  extract      # File extraction
  fzf          # Fuzzy finder
  history      # History search
  ssh          # SSH host highlighting
)
```

## Aliases

Oh My Bash comes with many useful aliases. View them with:
```bash
alias | grep -E "(git|docker|ssh)"
```

## Performance Tips

If the prompt feels slow:
1. Disable unused plugins
2. Set `DISABLE_UNTRACKED_FILES_DIRTY="true"` for large repos
3. Use `DISABLE_AUTO_UPDATE="true"` to prevent auto-updates

## Zellij Integration

The configuration automatically:
- Sets proper window titles for Zellij
- Works with Zellij's status bar
- Maintains compatibility with Zellij keybindings 