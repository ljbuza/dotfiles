#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
state_home="${XDG_STATE_HOME:-$HOME/.local/state}"
backup_dir="$state_home/dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
install_packages=true
link_configs=true
dry_run=false

usage() {
  printf '%s\n' \
    'Usage: ./bootstrap/install.sh [--packages-only | --link-only] [--dry-run]' \
    '' \
    '  --packages-only  Install packages but do not link configuration.' \
    '  --link-only      Link configuration but do not install packages.' \
    '  --dry-run        Print filesystem changes without making them.'
}

for argument in "$@"; do
  case "$argument" in
    --packages-only) link_configs=false ;;
    --link-only) install_packages=false ;;
    --dry-run) dry_run=true ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n' "$argument" >&2; usage >&2; exit 2 ;;
  esac
done

run() {
  if $dry_run; then
    printf '+ '
    printf '%q ' "$@"
    printf '\n'
  else
    "$@"
  fi
}

package_names() {
  sed -E '/^[[:space:]]*(#|$)/d' "$1"
}

install_arch_packages() {
  if [[ ! -r /etc/arch-release ]]; then
    printf 'Package installation is supported only on Arch Linux. Use --link-only elsewhere.\n' >&2
    exit 1
  fi

  mapfile -t arch_packages < <(package_names "$repo_dir/bootstrap/packages-arch.txt")
  run sudo pacman -Syu --needed "${arch_packages[@]}"

  mapfile -t aur_packages < <(package_names "$repo_dir/bootstrap/packages-aur.txt")
  if ((${#aur_packages[@]})); then
    if command -v yay >/dev/null 2>&1; then
      run yay -S --needed "${aur_packages[@]}"
    elif command -v paru >/dev/null 2>&1; then
      run paru -S --needed "${aur_packages[@]}"
    else
      printf 'AUR packages skipped (install yay or paru, then run): %s\n' "${aur_packages[*]}"
    fi
  fi
}

backup_target() {
  local target="$1"
  local relative="${target#$HOME/}"
  run mkdir -p "$backup_dir/$(dirname -- "$relative")"
  run mv "$target" "$backup_dir/$relative"
  printf 'Backed up %s to %s\n' "$target" "$backup_dir/$relative"
}

link_item() {
  local source="$1"
  local target="$2"

  run mkdir -p "$(dirname -- "$target")"
  if [[ -L "$target" && "$(readlink -f -- "$target")" == "$(readlink -f -- "$source")" ]]; then
    return
  fi
  if [[ -e "$target" || -L "$target" ]]; then
    backup_target "$target"
  fi
  run ln -s "$source" "$target"
}

install_dms_settings() {
  local dms_target="$config_home/DankMaterialShell"
  run mkdir -p "$dms_target"
  link_item "$repo_dir/DankMaterialShell/firefox.css" "$dms_target/firefox.css"
  link_item "$repo_dir/DankMaterialShell/zen.css" "$dms_target/zen.css"

  if [[ ! -e "$dms_target/settings.json" ]]; then
    run cp "$repo_dir/DankMaterialShell/settings.portable.json" "$dms_target/settings.json"
  else
    printf 'Preserving existing %s\n' "$dms_target/settings.json"
  fi
  if [[ ! -e "$dms_target/plugin_settings.json" ]]; then
    run cp "$repo_dir/DankMaterialShell/plugin_settings.portable.json" "$dms_target/plugin_settings.json"
  else
    printf 'Preserving existing %s\n' "$dms_target/plugin_settings.json"
  fi
}

install_configs() {
  local config_items=(
    alacritty
    ghostty
    hypr
    kitty
    nvim
    nwg-look
    swaync
    waybar
    starship.toml
  )

  for item in "${config_items[@]}"; do
    [[ -e "$repo_dir/$item" ]] || continue
    link_item "$repo_dir/$item" "$config_home/$item"
  done

  link_item "$repo_dir/portable/uwsm" "$config_home/uwsm"

  link_item "$repo_dir/home/.zshenv" "$HOME/.zshenv"
  link_item "$repo_dir/home/.zprofile" "$HOME/.zprofile"
  link_item "$repo_dir/home/.zshrc" "$HOME/.zshrc"
  install_dms_settings

  if [[ ! -e "$config_home/zsh/local.zsh" ]]; then
    run mkdir -p "$config_home/zsh"
    run cp "$repo_dir/zsh/local.zsh.example" "$config_home/zsh/local.zsh"
  fi
}

if $install_packages; then
  install_arch_packages
fi

if $link_configs; then
  install_configs
fi

if $install_packages && ! $dry_run; then
  sudo systemctl enable NetworkManager.service >/dev/null 2>&1 || true
  sudo systemctl enable bluetooth.service >/dev/null 2>&1 || true
fi

printf '\nBootstrap complete.\n'
printf 'Next: select Hyprland at login, run `dms doctor`, and open Neovim once.\n'
printf 'For Codex, run `codex` in Ghostty and choose Sign in with ChatGPT.\n'
printf 'Launch the ChatGPT desktop app from DMS or run `chatgpt`.\n'
if [[ "${SHELL:-}" != */zsh ]]; then
  printf 'Optional: set Zsh as your login shell with `chsh -s /usr/bin/zsh`.\n'
fi
