# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A [chezmoi](https://www.chezmoi.io/) dotfiles repository for a DevOps/Kubernetes-focused development environment running on Debian/Ubuntu. Chezmoi maps files using naming conventions: `dot_` prefix → `.` in home, `dot_config/` → `~/.config/`.

## Applying changes

```bash
# Apply all dotfiles to home directory
chezmoi apply

# Preview changes before applying
chezmoi diff

# Apply a single file
chezmoi apply ~/.config/fish/config.fish
```

## Bootstrap a new machine

```bash
# 1. Run bootstrap (system packages, Docker, FiraCode Nerd Fonts, mise, Fish, Fisher/Tide)
bash debian-startup.sh
# 2. Reboot, then apply dotfiles
mise x chezmoi -- chezmoi init --apply thewalterman
# 3. Install all mise-managed tools
mise install
# 4. Open nvim and wait for lazy.nvim to install plugins
nvim
```

TPM (Tmux Plugin Manager) is not auto-installed: clone it manually at `~/.tmux/plugins/tpm` and run `prefix + I` inside tmux to fetch plugins.

## Architecture

### File naming (chezmoi conventions)

- `dot_foo` → `~/.foo`
- `dot_config/bar/` → `~/.config/bar/`
- `*.tmpl` → processed as Go templates before deployment (e.g. `dot_gitconfig.tmpl` injects email/name from chezmoi data)

### Runtime tool management

All CLI tools (neovim, kubectl, helm, k9s, lazygit, yazi, node, python, java, etc.) are managed by **mise** (`dot_config/mise/config.toml`). Do not assume system-installed versions. Tmux is installed from apt (see `debian-startup.sh`).

### Shell startup chain

Fish (`dot_config/fish/config.fish`) initializes aliases/abbreviations, then mise → zoxide. Bash (`dot_bashrc`) mirrors this chain as fallback.

### Key configs

| File | Purpose |
|------|---------|
| `dot_config/fish/config.fish` | Fish shell with abbreviations for git, docker, k8s, helm, flux |
| `dot_config/fish/fish_plugins` | Fisher plugin list (tide, fzf.fish); `fisher update` reads this file |
| `dot_config/mise/config.toml` | Pinned versions for all dev tools |
| `dot_config/nvim/` | LazyVim-based Neovim with custom plugins |
| `dot_config/k9s/` | K9s with custom hotkeys, aliases, skins, debug plugin |
| `dot_config/tmux/tmux.conf` | Tmux config with TPM plugins (resurrect, continuum, yank, vim-tmux-navigator) |
| `dot_config/tmux/devops.sh` | Recreates the devops layout: window `dev` (nvim + claude), window `ops` (k9s + shell) |
| `dot_wezterm.lua` | WezTerm terminal with FiraCodeNerdFont, Dark Pastel theme |
| `dot_gitconfig.tmpl` | Templated git config (email/name from chezmoi data or defaults) |
| `dot_claude/CLAUDE.md` | Global Claude Code config — deploys to `~/.claude/CLAUDE.md` |
| `dot_claude/agents/` | Custom Claude Code subagent definitions — deploys to `~/.claude/agents/` |

### Tmux devops layout

`devops.sh` launches nvim/claude/k9s as the **top-level process of each pane** (passed as shell-command argument to `new-session`/`new-window`/`split-window`), not via `send-keys` into a shell. Combined with `remain-on-exit on` (set per-pane), this means: when the app exits, the pane becomes "dead" instead of closing, and `prefix + R` respawns the original command — mimicking zellij's `command` pane behavior. The bottom shell pane in the `ops` window has the same treatment.

### Neovim plugins (LazyVim base)

Custom additions live in `dot_config/nvim/lua/plugins/`. Key plugins: bufferline (Shift+arrows), smart-splits (Alt+arrows), nvim-spider, snacks (picker with hidden files), tokyonight (transparent).

### Fish abbreviations pattern

Abbreviations use `abbr -a name 'expansion'`. Many use `--set-cursor='%'` for cursor positioning mid-command — the `%` is replaced by the cursor position at expansion (e.g. `gc` expands to `git commit -m ''` with cursor inside quotes).

### Fish functions

Custom functions live in `dot_config/fish/functions/`:

- `y` — Yazi file browser with CWD integration (changes shell directory on exit)
- `fcd` — fzf directory picker (uses `fdfind` + `eza` preview) that `cd`s into the selection
- `fkube` — Kubernetes fuzzy-select utilities
- `fssh` — SSH helper
- `devops` — Dispatch for the tmux devops layout. If `$KUBECONFIG` is set (typically from a project-local `mise.toml`), creates/attaches a session named after the current directory. Otherwise attaches to the most recent live session, or falls back to a default `devops` session. Mirrored as a bash function in `dot_bashrc`.

### Claude Code agents

`dot_claude/agents/` contains subagent definitions that deploy to `~/.claude/agents/`. Each file is a markdown file with YAML frontmatter (`name`, `description`, `model`, `tools`) followed by a system prompt. Current agents:

- `coder.md` — writes Terraform/K8s/Bash/Python code following strict conventions (Sonnet)
- `planner.md` — researches and produces implementation plans, never writes code (Opus)
- `security-reviewer.md` — reviews infrastructure diffs for security findings, never modifies files (Opus)

### Chezmoi ignore

`.chezmoiignore` lists files in the repo that chezmoi does NOT deploy: `README.md`, `CLAUDE.md`, `debian-startup.sh`. These are meta/bootstrap files only.

### Chezmoi template data

Template variables (`.email`, `.name`, `.username`, `.helper`) are sourced from `~/.config/chezmoi/chezmoi.toml` (not tracked in this repo). View or edit with `chezmoi edit-config`. Defaults are hardcoded in `dot_gitconfig.tmpl` as fallbacks.

### WezTerm pane/tab keybindings

| Binding | Action |
|---------|--------|
| Ctrl+Shift+{ / } | Rotate tabs left/right |
| Ctrl+Shift+\| | Split pane horizontal |
| Ctrl+Shift+? | Split pane vertical |
