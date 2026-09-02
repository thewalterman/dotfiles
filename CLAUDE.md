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
# 1. Run bootstrap (system packages, Docker, FiraCode Nerd Fonts, mise, Fish)
bash debian-startup.sh
# 2. Reboot, then apply dotfiles
mise x chezmoi -- chezmoi init --apply thewalterman
# 3. Install all mise-managed tools
mise install
# 4. Open nvim and wait for lazy.nvim to install plugins
nvim
```

## Architecture

### File naming (chezmoi conventions)

- `dot_foo` → `~/.foo`
- `dot_config/bar/` → `~/.config/bar/`
- `*.tmpl` → processed as Go templates before deployment (e.g. `dot_gitconfig.tmpl` injects email/name from chezmoi data)

### Runtime tool management

All CLI tools (neovim, kubectl, helm, k9s, lazygit, yazi, node, ast-grep, stern, tree-sitter, zellij, starship, etc.) are managed by **mise** (`dot_config/mise/config.toml`). Do not assume system-installed versions.

### Shell startup chain

Fish (`dot_config/fish/config.fish`) initializes aliases/abbreviations, then mise → starship → zoxide. Bash (`dot_bashrc`) mirrors this chain as fallback.

### Key configs

| File | Purpose |
| ------ | --------- |
| `dot_config/fish/config.fish` | Fish shell with abbreviations for git, docker, k8s, helm, flux |
| `dot_config/fish/fish_variables` | Fish universal variables (zoxide data dir, etc.) — tracked so settings survive `chezmoi apply` on a new machine |
| `dot_config/mise/config.toml` | Pinned versions for all dev tools |
| `dot_config/starship.toml` | Starship prompt config (kubernetes context in right prompt, per-language symbols) |
| `dot_config/nvim/` | LazyVim-based Neovim with custom plugins |
| `dot_config/k9s/` | K9s with custom hotkeys, aliases, skins, debug plugin |
| `dot_config/zellij/config.kdl` | Zellij config: tmux-style `Ctrl+b` prefix mode (built-in), larger scrollback |
| `dot_config/zellij/layouts/devops.kdl` | Devops layout: tab `dev` (nvim + claude), tab `ops` (k9s + shell) |
| `dot_config/zellij/devops.sh` | Attaches to (or creates, via the `devops` layout) a named zellij session |
| `dot_wezterm.lua` | WezTerm terminal with FiraCodeNerdFont, Dark Pastel theme |
| `dot_gitconfig.tmpl` | Templated git config (email/name from chezmoi data or defaults) |
| `dot_claude/CLAUDE.md` | Global Claude Code config — deploys to `~/.claude/CLAUDE.md` |
| `dot_claude/agents/` | Custom Claude Code subagent definitions — deploys to `~/.claude/agents/` |
| `dot_claude/skills/` | Custom Claude Code skills — deploys to `~/.claude/skills/` |

### Zellij devops layout

`layouts/devops.kdl` declares nvim/claude/k9s as `command` panes in two tabs (`dev`, `ops`). Zellij's default behavior for command panes already matches tmux's old `remain-on-exit` + `prefix + R` setup: when the command exits, the pane stays open and pressing `ENTER` re-runs it — no extra config needed. `devops.sh` does `zellij attach --create <session> options --default-layout devops`, which attaches to an existing session or creates one with this layout, keyed by directory name when `$KUBECONFIG` is set.

### Neovim plugins (LazyVim base)

Custom additions live in `dot_config/nvim/lua/plugins/`. Key plugins: bufferline (Shift+arrows), smart-splits (Alt+arrows), nvim-spider, snacks (picker with hidden files), tokyonight (transparent).

### Fish abbreviations pattern

Abbreviations use `abbr -a name 'expansion'`. Many use `--set-cursor='%'` for cursor positioning mid-command — the `%` is replaced by the cursor position at expansion (e.g. `gc` expands to `git commit -m ''` with cursor inside quotes).

### Fish prompt (starship)

Prompt is [starship](https://starship.rs/), managed by mise and configured via `dot_config/starship.toml`. Initialized in `config.fish` with `starship init fish | source`.

### Fish functions

Custom functions live in `dot_config/fish/functions/`:

- `y` — Yazi file browser with CWD integration (changes shell directory on exit)
- `fcd` — fzf directory picker (uses `fd` + `eza` preview) that `cd`s into the selection
- `fkube` — Kubernetes fuzzy-select utilities
- `fssh` — SSH helper
- `devops` — With no args, attaches to (or creates, via the `devops` layout) a zellij session named after the current directory's basename. With a session name arg, plain `zellij attach <name>` instead — tab-completed from `zellij list-sessions` via `dot_config/fish/completions/devops.fish`. Always targets a named session — `zellij attach` with no name errors out (and would kill the shell via `exec`) once 2+ sessions exist. Mirrored as a bash function in `dot_bashrc`.

### Claude Code agents

`dot_claude/agents/` contains subagent definitions that deploy to `~/.claude/agents/`. Each file is a markdown file with YAML frontmatter (`name`, `description`, `model`, `tools`) followed by a system prompt. Current agents:

- `coder.md` — writes Terraform/K8s/Bash/Python code following strict conventions (Sonnet)
- `planner.md` — researches and produces implementation plans, never writes code (Opus)
- `security-reviewer.md` — reviews infrastructure diffs for security findings, never modifies files (Opus)

### Claude Code skills

`dot_claude/skills/` contains skill definitions (each a `SKILL.md` with YAML frontmatter `name`/`description`) that deploy to `~/.claude/skills/`. They gate infra changes on specific tool invocations rather than manual review steps:

- `tf-fmt-validate`, `tf-plan-diff`, `cost-estimate` — Terraform format/validate, plan diff, and infracost estimate
- `k8s-dry-run`, `rbac-diff` — Kubernetes/Helm server-side dry run and RBAC before/after diff
- `policy-scan`, `secrets-scan` — tfsec/kube-score static scanning, gitleaks secret scanning
- `shellcheck-gate` — shellcheck on any written/edited bash script
- `provider-docs-lookup` — fetch pinned-version docs for a Terraform provider resource, K8s API object, or Helm chart

Each skill expects its underlying tool (`terraform`, `infracost`, `tfsec`, `kube-score`, `gitleaks`, `shellcheck`) on `PATH` via mise and tells the user to `mise use -g <tool>` if missing — none of these are in the default `dot_config/mise/config.toml` tool set.

### Chezmoi ignore

`.chezmoiignore` lists files in the repo that chezmoi does NOT deploy: `README.md`, `CLAUDE.md`, `debian-startup.sh`. These are meta/bootstrap files only.

### Chezmoi template data

Template variables (`.email`, `.name`, `.username`, `.helper`) are sourced from `~/.config/chezmoi/chezmoi.toml` (not tracked in this repo). View or edit with `chezmoi edit-config`. Defaults are hardcoded in `dot_gitconfig.tmpl` as fallbacks.

### WezTerm pane/tab keybindings

| Binding | Action |
| --------- | -------- |
| Ctrl+Shift+{ / } | Rotate tabs left/right |
| Ctrl+Shift+\| | Split pane horizontal |
| Ctrl+Shift+? | Split pane vertical |
