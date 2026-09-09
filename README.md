# Larry's DMS workstation dotfiles

This repository captures the portable parts of the current Arch Linux workstation: Hyprland, DankMaterialShell (DMS), Neovim/LazyVim, Zsh/Zinit, terminals, and supporting desktop tools.

Machine-local state, display layouts, histories, credentials, API keys, and work-specific paths are intentionally excluded. Portable replacements that must not overwrite the source workstation's live files are kept under `portable/`.

## New laptop

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

Keep these lists curated. They describe the workstation experience, not every package installed on the source machine.
