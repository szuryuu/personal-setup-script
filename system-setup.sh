#!/bin/bash

# Coloring
INFO="\e[34m"
SUCCESS="\e[32m"
WARNING="\e[33m"
RESET="\e[0m"

info()
{
  echo -e "${INFO}$1${RESET}"
}

success()
{
  echo -e "${SUCCESS}$1${RESET}"
}

warning ()
{
  echo -e "${WARNING}$1${RESET}"
}

# ============================================
# Test mode
TEST_MODE="${TEST_MODE:-false}"

CORE_PACKAGES=(
  "base-devel"
  "curl"
  "docker"
  "fastfetch"
  "fzf"
  "git"
  "htop"
  "jq"
  "neovim"
  "php"
  "tar"
  "unzip"
  "wget"
  "xz"
  "zsh"
  "zip"
)

# Skip in test mode
GUI_PACKAGES=(
  "cava"
  "discord"
  "kitty"
  "mpv"
  "rofi"
  "spotify-launcher"
  "swaync"
  "thunar"
  "waybar"
)

AUR_PACKAGES=(
  "cmatrix-git"
  "postman-bin"
  "zen-browser-bin"
)

# ============================================

# Installing Packages

if [["$TEST_MODE" == "true"]]; then
    info "[+] TEST MODE: Installing core packages only"
    PACKAGES=("${CORE_PACKAGES[@]}")
else
    info "[+] Installing all packages"
    PACKAGES=("${CORE_PACKAGES[@]}" "${GUI_PACKAGES[@]}")
fi

info "[+] Installing Packages (Pacman)"
sudo pacman -Syu --needed --noconfirm "${PACKAGES[@]}" { warning "Pacman failed"; exit 1; }

if [[ "$TEST_MODE" == "true" ]]; then
  warning "[+] TEST MODE: Skipping AUR and external tools"
  exit 0
fi

info "[+] Installing Packages (Direct)"
if ! command -v yay &>/dev/null; then
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
else
  success "[-] yay already installed"
fi

if [ -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  omz update
fi

if ! command -v rustup &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    rustup toolchain install nightly
fi

if ! command -v bun &>/dev/null; then
    curl -fsSL https://bun.sh/install | bash
fi

info "[+] Installing Packages (AUR)"
yay -S --clean --noconfirm "${AUR_PACKAGES[@]}"

# =============================================

info "[+] Configuring Git"

GIT_EMAIL="${GIT_EMAIL:-user@example.com}"
GIT_NAME="${GIT_NAME:-Default User}"

git config --global user.email "$GIT_EMAIL"
git config --global user.name "$GIT_NAME"
git config --global core.editor "nvim"

success "[+] Git configured with: $GIT_NAME <$GIT_EMAIL>"

# ============================================

info "[+] Config"

if [ -d "$HOME/.config" ]; then
  warning "[-] Backing up existing config.."
  cp -r "$HOME/.config" "$HOME/.config-backup"
fi

git clone https://github.com/szuryuu/archway.git ~/Personal/temp/archway
cp -r ~/Personal/temp/archway/* ~/.config/ 2>/dev/null
cp -r ~/Personal/temp/archway/.* ~/.config/ 2>/dev/null
rm -rf ~/Personal/temp/archway

success "[+] Setup Completed"
