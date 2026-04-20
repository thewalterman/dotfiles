# dotfiles

Powered by [chezmoi](https://www.chezmoi.io/) and [mise](https://mise.jdx.dev/).

## New machine setup

1. Run the bootstrap script:

   ```bash
   curl https://raw.githubusercontent.com/thewalterman/dotfiles/refs/heads/main/debian-startup.sh | bash
   ```

2. Reboot.

3. Apply dotfiles:

   ```bash
   mise x chezmoi -- chezmoi init --apply thewalterman
   ```

4. Let mise install all tools:

   ```bash
   mise install
   ```

5. Open Neovim and wait for plugins to install:

   ```bash
   nvim
   ```

6. Install TPM (Tmux Plugin Manager) and fetch plugins:

   ```bash
   git clone --depth=1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   ```

   Then launch `tmux` and press `Ctrl+b` `Shift+i` to install the plugins declared in `~/.config/tmux/tmux.conf`.
