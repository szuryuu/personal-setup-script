# Personal Setup Script

This is a personal automation script designed for fresh Arch Linux installations. It streamlines the process of setting up directory structures, installing essential packages, and configuring the development environment according to my specific workflow.

> **DISCLAIMER:** This script is tailored for my specific hardware and preferences. **Review the code before running it on your machine.** Use it at your own risk. I am not responsible for any data loss, broken systems, or package conflicts that may arise.

## Features

-   **Automated Directory Structure**: Instantly generates a clean hierarchy for `Projects`, `Archives`, `Work`, `Resources`, and `Systems` to keep the home directory organized.
-   **Package Management**: Automatically installs and configures:
    -   **Core**: `base-devel`, `docker`, `neovim`, `zsh`, `git`, and more.
    -   **GUI**: `kitty`, `waybar`, `rofi`, `thunar`, `discord`, etc.
    -   **AUR**: Handles AUR packages like `zen-browser-bin` using `yay` (auto-installed if missing).
-   **Dev Environment**: Sets up `rustup` (nightly), `bun`, and `oh-my-zsh` out of the box.
-   **System Configuration**: Applies global Git configurations, installs the **Monocraft** font, and syncs dotfiles.

## How to Use This Script

You can use this repository to rapidly bootstrap a fresh Arch Linux environment.

### Step 1: Clone the Repository

Clone this repository to your local machine:

```bash
git clone [https://github.com/szuryuu/personal-setup-script.git](https://github.com/szuryuu/personal-setup-script.git)
cd personal-setup-script
````

### Step 2: Configure Environment Variables

This script uses environment variables to configure your Git identity during setup. You can set these up using the provided example file or export them manually.

**Option A: Using the `.env` file (Recommended)**

```bash
cp .env.example .env
nano .env  # Update with your email and name
source .env
```

**Option B: Manually Exporting Variables**

```bash
export GIT_EMAIL="your.email@example.com"
export GIT_NAME="Your Name"
```

### Step 3: Run the Script

Execute the starter script. This will automatically grant execution permissions to the necessary sub-scripts and begin the installation process.

```bash
chmod +x starter.sh
./starter.sh
```

## Hyprland Configuration

This script automates the installation of the underlying system tools. The actual UI/UX configuration (Hyprland, Waybar, Rofi themes, etc.) is managed in a separate repository.

For the visual config and dotfiles, please refer to:
**[szuryuu/archway](https://github.com/szuryuu/archway)**

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
