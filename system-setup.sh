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

# =============================================

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

info "[+] Installing all packages"
PACKAGES=("${CORE_PACKAGES[@]}" "${GUI_PACKAGES[@]}")

info "[+] Installing Packages (Pacman)"
sudo pacman -Syu --needed --noconfirm "${PACKAGES[@]}" || { warning "Pacman failed"; exit 1; }

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

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no
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

# =============================================

info "[+] Configuring Fonts"

if ! command -v fc-list &>/dev/null; then
    sudo pacman -S --noconfirm fontconfig
fi

mkdir -p ~/.fonts
wget https://github.com/IdreesInc/Monocraft/releases/download/v4.1/Monocraft.ttc -O ~/.fonts/Monocraft.ttc
fc-cache -fv ~/.fonts

# =============================================

info "[+] Config"

if [ -d "$HOME/.config" ]; then
  warning "[-] Backing up existing config.."
  cp -r "$HOME/.config" "$HOME/.config-backup"
fi

git clone https://github.com/szuryuu/archway.git ~/Personal/temp/archway

shopt -s dotglob # Copy files without
cp -r ~/Personal/temp/archway/* ~/.config/ 2>/dev/null
shopt -u dotglob

rm -rf ~/Personal/temp/archway

success "[+] Setup Completed"
