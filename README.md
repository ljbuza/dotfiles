# Larry's DMS workstation dotfiles

This repository captures the portable parts of the current Arch Linux workstation: Hyprland, DankMaterialShell (DMS), Neovim/LazyVim, Zsh/Zinit, terminals, and supporting desktop tools.

Machine-local state, display layouts, histories, credentials, API keys, and work-specific paths are intentionally excluded. Portable replacements that must not overwrite the source workstation's live files are kept under `portable/`.

## New laptop: Arch Linux

Start from an installed, network-connected Arch Linux system and log in as your normal user. Install Git, clone this repository somewhere other than `~/.config`, then run the bootstrap:

```bash
sudo pacman -S --needed git
git clone git@github.com:ljbuza/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap/install.sh
```

If SSH access to GitHub is not configured yet, clone over HTTPS instead:

```bash
git clone https://github.com/ljbuza/dotfiles.git ~/.dotfiles
```

The bootstrap installs the curated Arch packages, installs the AUR package list when an AUR helper is available, backs up conflicting files, and links the managed configuration into your home directory. It does not copy secrets or machine-specific work configuration.

Useful modes:

```bash
./bootstrap/install.sh --packages-only
./bootstrap/install.sh --link-only
./bootstrap/install.sh --dry-run
```

After it completes:

1. Change the login shell if necessary with `chsh -s /usr/bin/zsh`.
2. Select the Hyprland session in the display manager and log in.
3. Run `dms doctor` and address any hardware-specific recommendations.
4. Open Neovim once and allow Lazy.nvim to install the plugins pinned in `nvim/lazy-lock.json`.
5. Put laptop-only or work-only shell settings in `~/.config/zsh/local.zsh`.

## New laptop: Ubuntu

For the complete Hyprland + DMS desktop, use Ubuntu 26.04 LTS or newer. DMS's
official Ubuntu packages currently require 26.04+, while the configuration-only
part of the bootstrap can be used on older Ubuntu releases with `--link-only`.

If the laptop is currently running Ubuntu 25.10, upgrade the operating system
before running the bootstrap:

```bash
sudo apt update
sudo apt dist-upgrade
sudo do-release-upgrade
sudo reboot
```

The release upgrader normally disables third-party repositories and PPAs. Leave
them disabled during the upgrade. After booting Ubuntu 26.04, the bootstrap adds
the DMS repositories again for the new Ubuntu release.

Start from an installed, network-connected Ubuntu system and run:

```bash
sudo apt update
sudo apt install -y git build-essential
git clone git@github.com:ljbuza/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap/install-ubuntu.sh
```

If GitHub SSH is not configured yet:

```bash
git clone https://github.com/ljbuza/dotfiles.git ~/.dotfiles
```

The Ubuntu bootstrap enables `universe`, adds the official DMS Launchpad PPAs,
installs the available Ubuntu package set, installs Codex with OpenAI's official
Linux installer, backs up conflicting configuration, and links the same desktop,
Neovim, Zsh, and terminal configuration used on Arch. Optional packages that are
not published for the installed Ubuntu release are reported and skipped.

Useful modes:

```bash
./bootstrap/install-ubuntu.sh --packages-only
./bootstrap/install-ubuntu.sh --link-only
./bootstrap/install-ubuntu.sh --skip-codex
./bootstrap/install-ubuntu.sh --dry-run
```

The ChatGPT desktop app is installed separately because its package depends on
the laptop architecture. Download the official Ubuntu `.deb` from
<https://learn.chatgpt.com/docs/linux/linux-app>, then run one of:

```bash
sudo apt install ~/Downloads/chatgpt_amd64.deb   # x86_64
sudo apt install ~/Downloads/chatgpt_arm64.deb   # ARM64
```

Then finish exactly as on Arch:

```bash
chsh -s /usr/bin/zsh
dms doctor
```

Log out, select Hyprland at the login screen, and log back in. Without a display
manager, start it from a TTY with `uwsm start hyprland.desktop`. Open Neovim once
afterward so Lazy.nvim can install the pinned plugins.

## Codex and ChatGPT

The package manifests install:

- `openai-codex` from the official Arch repositories for terminal use in Ghostty
- `chatgpt-desktop-bin` from the AUR for the ChatGPT desktop app

After bootstrapping, open a project in Ghostty and sign in:

```bash
cd ~/Documents/work/your-project
codex
```

Choose **Sign in with ChatGPT** on the first run. Launch the desktop app through the DMS application launcher or with:

```bash
chatgpt
```

OpenAI currently describes the Linux desktop app as a preview supported on selected Ubuntu, Debian, and Fedora releases. Arch is not formally supported, and `chatgpt-desktop-bin` is community AUR packaging of the Linux application. If the bootstrap skips AUR packages because `yay` or `paru` is unavailable, install an AUR helper and run:

```bash
yay -S --needed chatgpt-desktop-bin walker elephant
```

Do not copy `~/.codex/auth.json` between computers. Sign in normally on the laptop. Codex authentication, histories, databases, installation IDs, and other generated `~/.codex` state are deliberately excluded from this repository.

## DMS settings

`DankMaterialShell/settings.portable.json` retains the desktop appearance and behavior while removing display profiles, GPU identifiers, usage histories, absolute wallpaper paths, and authentication material. On first bootstrap it becomes `~/.config/DankMaterialShell/settings.json`. Existing DMS settings are preserved.

To refresh the portable snapshot from the current machine after changing DMS settings:

```bash
./bootstrap/capture-dms-settings.sh
```

Review the resulting diff before committing it. The capture script sanitizes known machine-local and secret fields, but review remains mandatory whenever upstream DMS adds new settings.

## Local shell configuration

The tracked Zsh setup contains the reusable interactive experience. Optional SDKs, private environment variables, mount aliases, device addresses, and project paths belong in the ignored file:

```text
~/.config/zsh/local.zsh
```

Start from `zsh/local.zsh.example`. Keep secrets in a password manager, `direnv`, or another dedicated secret store—not in this repository.

## Updating package manifests

The bootstrap reads:

- `bootstrap/packages-arch.txt` for official Arch packages
- `bootstrap/packages-aur.txt` for AUR packages
- `bootstrap/packages-ubuntu.txt` for required Ubuntu packages
- `bootstrap/packages-ubuntu-optional.txt` for release-dependent Ubuntu packages

Keep these lists curated. They describe the workstation experience, not every package installed on the source machine.
