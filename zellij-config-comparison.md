# Zellij Configuration Comparison: Default vs Omakub

## Key Differences Overview

### 1. **Default Mode**
- **Default Zellij**: `normal` mode - You start with full access to Zellij commands
- **Omakub**: `locked` mode - Most keyboard input goes directly to terminal applications

### 2. **Keybinding Philosophy**
- **Default Zellij**: Traditional multiplexer approach with modifier keys (Ctrl+key combinations)
- **Omakub**: Modal approach similar to Vim, with locked mode as default

### 3. **Mode Switching**
- **Default Zellij**: 
  - `Ctrl+g` to enter locked mode
  - Various Ctrl combinations to enter other modes
- **Omakub**: 
  - `Ctrl+g` to enter normal mode (reversed!)
  - Always returns to locked mode after operations

### 4. **Critical Ctrl+C Behavior**
- **Default Zellij**: Ctrl+C passes through to applications (interrupt signal works)
- **Omakub**: Ctrl+C is bound to various Zellij commands:
  - In scroll/search mode: Returns to locked mode
  - When renaming: Cancels the operation
  - This BLOCKS the interrupt signal from reaching applications

## Detailed Keybinding Differences

### In Normal/Locked Mode

| Action | Default Zellij | Omakub |
|--------|---------------|---------|
| Switch modes | `Ctrl+g` → locked | `Ctrl+g` → normal |
| New pane | `Alt+n` | Not available in locked |
| Navigate panes | `Alt+h/j/k/l` | `Alt+h/j/k/l` (same) |
| Quit | `Ctrl+q` | Only in normal mode |

### Mode Behavior

**Default Zellij**:
```kdl
// Starts in normal mode
default_mode "normal"

// Uses default keybindings plus custom ones
keybinds {
    // your custom bindings added to defaults
}
```

**Omakub**:
```kdl
// Starts in locked mode
default_mode "locked"

// Completely replaces all default keybindings
keybinds clear-defaults=true {
    // only Omakub's custom bindings exist
}
```

### The Ctrl+C Issue

**Default Zellij** - No Ctrl+C bindings in most modes:
```kdl
// Ctrl+C is NOT bound, so it passes through to applications
scroll {
    bind "e" { EditScrollback; }
    bind "s" { SwitchToMode "EnterSearch"; }
    // No Ctrl+C binding here
}
```

**Omakub** - Ctrl+C is bound in multiple modes:
```kdl
scroll {
    bind "Ctrl c" { ScrollToBottom; SwitchToMode "locked"; }
}
entersearch {
    bind "Ctrl c" { SwitchToMode "scroll"; }
}
shared_among "renametab" "renamepane" {
    bind "Ctrl c" { SwitchToMode "locked"; }
}
```

## Why This Design?

### Omakub's Philosophy:
1. **Safety First**: Locked mode prevents accidental Zellij commands
2. **Vim-like**: Modal interface familiar to Vim users
3. **Quick Return**: Operations automatically return to locked mode
4. **Minimal Interference**: In locked mode, most keys go to your applications

### Trade-offs:
- ✅ Less accidental pane/tab operations
- ✅ Clean modal interface
- ❌ Ctrl+C doesn't work as interrupt signal
- ❌ Need to enter normal mode for any Zellij operation

## Other Notable Omakub Customizations

1. **Compact layout** by default
2. **Force quit on close** instead of detach
3. **Clear all defaults** - complete control over keybindings
4. **Git status in status bar** for development workflows
5. **Automatic mode switches** - returns to locked after most operations

## Summary

Omakub's configuration is a highly opinionated take on Zellij that prioritizes:
- Modal operation (like Vim)
- Staying out of your way (locked by default)
- Preventing accidents (no accidental pane closes)

But it comes with the cost of intercepting some standard signals like Ctrl+C, which can be frustrating for developers who need to interrupt processes frequently.