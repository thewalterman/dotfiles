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
  apt-transport-https
  bash-completion
  build-essential
  ca-certificates
  curl
  debianutils
  dnsmasq
  file
  findutils
  fish
  fontconfig
  git
  gnupg
  iproute2
  libnss3-tools
  libssl-dev
  mtr
  nano
  ncdu
  nfs-common
  nmap
  openssh-client
  openssh-server
  openssl
  openvpn
  procps
  software-properties-common
  sudo
  tar
  tmux
  ufw
  unzip
  vim
  wget
  xclip
  zip
)

EXTRA_PACKS=(
  imagemagick
  luarocks
  neofetch
  pass
  pass-otp
  sshpass
)

info "Updating and installing apt packages..."
sudo apt-add-repository -y ppa:fish-shell/release-4
sudo apt update && sudo apt upgrade -y
sudo apt install -y "${BASE_PACKS[@]}"
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
  docker_distro_id="$(. /etc/os-release && echo "$ID")"
  docker_codename="$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")"

  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL "https://download.docker.com/linux/${docker_distro_id}/gpg" -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  sudo tee /etc/apt/sources.list.d/docker.sources >/dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/${docker_distro_id}
Suites: ${docker_codename}
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
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

info "Cleaning up..."
sudo apt autoclean && sudo apt autoremove -y
touch ~/.hushlogin
success "Cleanup complete"

echo ""
success "Setup complete! Reboot"
