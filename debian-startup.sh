#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info() { echo -e "${BLUE}==>${NC} $1"; }
success() { echo -e "${GREEN}==>${NC} $1"; }
error() { echo -e "${RED}==>${NC} $1" >&2; }

# Check sudo access upfront
if ! sudo -v; then
  error "This script requires sudo access"
  exit 1
fi

# Keep sudo alive throughout the script
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

BASE_PACKS=(
  sudo
  make
  wget
  curl
  vim
  nano
  git
  tmux
  tar
  zip
  unzip
  gnupg
  apt-transport-https
  ca-certificates
  software-properties-common
  libnss3-tools
  libssl-dev
)

ESSENTIAL_PACKS=(
  gcc
  build-essential
  bash-completion
  net-tools
  debianutils
  findutils
  file
  procps
  nmap
  ufw
  ncdu
  xclip
  xsel
  mtr
  openssl
  openssh-client
  openssh-server
  openvpn
  dnsmasq
  nfs-common
)

EXTRA_PACKS=(
  zoxide
  fontconfig
  mkcert
  age
  neofetch
  btop
  gdu
  duf
  bat
  ripgrep
  fd-find
  luarocks
  sshpass
  pass
  pass-otp
  eza
  fzf
  imagemagick
  fish
)

info "Updating and installing apt packages..."
sudo apt-add-repository -y ppa:fish-shell/release-4
sudo apt update && sudo apt upgrade -y
sudo apt install -y "${BASE_PACKS[@]}"
sudo apt install -y "${ESSENTIAL_PACKS[@]}"
sudo apt install -y "${EXTRA_PACKS[@]}"
success "Apt packages installed"

info "Installing Nerd Fonts (FiraCode)..."
fonts_zip="FiraCode.zip"
fonts_dir="$HOME/.local/share/fonts"
mkdir -p "$fonts_dir"
if ! ls "$fonts_dir"/FiraCode*.ttf &>/dev/null; then
  wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$fonts_zip
  unzip -o "$fonts_zip" -d "$fonts_dir"
  rm -f "$fonts_zip"
  fc-cache -fv
  success "Nerd Fonts installed"
else
  info "FiraCode fonts already installed, skipping"
fi

info "Setting up Docker..."
if ! command -v docker &>/dev/null; then
  curl -fsSL https://get.docker.com | sh
  sudo usermod -aG docker "$USER"
  success "Docker installed"
else
  info "Docker already installed, skipping"
fi

info "Setting up LazyVim..."
if [[ ! -d ~/.config/nvim ]] || [[ ! -f ~/.config/nvim/lazy-lock.json ]]; then
  rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git
  success "LazyVim installed"
else
  info "LazyVim already configured, skipping"
fi

info "Installing mise..."
if ! command -v mise &>/dev/null; then
  curl https://mise.run | sh
  success "mise installed"
else
  info "mise already installed, skipping"
fi

info "Setting Fish as default shell..."
fish_path=$(which fish)
if [[ "$SHELL" != "$fish_path" ]]; then
  sudo chsh -s "$fish_path" "$(whoami)"
  success "Fish set as default shell"
else
  info "Fish already default shell, skipping"
fi

info "Installing Fisher and Fish plugins..."
if ! fish -c "type -q fisher" &>/dev/null; then
  fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
  success "Fisher installed"
else
  info "Fisher already installed, skipping"
fi
fish -c "fisher update"
success "Fish plugins installed"

info "Configuring Tide prompt..."
fish -c "tide configure --auto --style=Lean --prompt_colors='True color' --show_time=No --lean_prompt_height='Two lines' --prompt_connection=Disconnected --prompt_spacing=Sparse --icons='Few icons' --transient=Yes"
success "Tide configured"

info "Cleaning up..."
sudo apt autoclean && sudo apt autoremove -y
touch ~/.hushlogin
success "Cleanup complete"

echo ""
success "Setup complete! Reboot"
