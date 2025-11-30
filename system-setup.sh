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

OFFICIAL_PACKAGES=(
  "base-devel"
  "curl"
  "cava"
  "discord"
  "docker"
  "docker-compose"
  "fastfetch"
  "fzf"
  "git"
  "htop"
  "jq"
  "kitty"
  "mpv"
  "neovim"
  "php"
  "pipewire"
  "rofi"
  "spotify-launcher"
  "swaync"
  "tar"
  "thunar"
  "unzip"
  "waybar"
  "wget"
  "xz"
  "zsh"
  "zip"
)

AUR_PACKAGES=(
  "cmatrix-git"
  "postman-bin"
  "zen-browser-bin"
)

# ============================================

# Installing Packages
info "[+] Installing Packages (Pacman)"
sudo pacman -Syu --needed --noconfirm "${OFFICIAL_PACKAGES[@]}" { warning "Pacman failed"; exit 1; }

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
  omz update
fi

if ! command -v rustup &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh &>/dev/null
    rustup toolchain install nightly
fi

if ! command -v bun &>/dev/null; then
    curl -fsSL https://bun.sh/install | bash &>/dev/null
fi

info "[+] Installing Packages (AUR)"
yay -S --clean --noconfirm "${AUR_PACKAGES[@]}"

# =============================================

info "[+] Configuring Git"

warning "[?] Enter your email address"
read email
warning "[?]Enter your name"
read name

git config --global user.email "$email"
git config --global user.name "$name"
git config --global core.editor "nvim"

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
