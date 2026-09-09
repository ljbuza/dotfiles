#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
state_home="${XDG_STATE_HOME:-$HOME/.local/state}"
backup_dir="$state_home/dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
install_packages=true
link_configs=true
install_codex=true
dry_run=false

usage() {
  printf '%s\n' \
    'Usage: ./bootstrap/install-ubuntu.sh [options]' \
    '' \
    '  --packages-only  Install packages but do not link configuration.' \
    '  --link-only      Link configuration but do not install packages.' \
    '  --skip-codex     Do not install the Codex CLI.' \
    '  --dry-run        Print changes without making them.'
}

for argument in "$@"; do
  case "$argument" in
    --packages-only) link_configs=false ;;
    --link-only) install_packages=false; install_codex=false ;;
    --skip-codex) install_codex=false ;;
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

check_supported_ubuntu() {
  if [[ ! -r /etc/os-release ]]; then
    printf 'Cannot identify this operating system. Use --link-only to install configuration only.\n' >&2
    exit 1
  fi

  # shellcheck disable=SC1091
  source /etc/os-release
  if [[ "${ID:-}" != ubuntu ]]; then
    printf 'Package installation is supported only on Ubuntu. Use --link-only elsewhere.\n' >&2
    exit 1
  fi
  if ! dpkg --compare-versions "${VERSION_ID:-0}" ge 26.04; then
    printf 'The full DMS desktop requires Ubuntu 26.04 LTS or newer. Use --link-only on %s.\n' "${VERSION_ID:-unknown}" >&2
    exit 1
  fi
}

install_ubuntu_packages() {
  check_supported_ubuntu

  # Minimal Ubuntu installs do not always include add-apt-repository.
  run sudo apt-get update
  run sudo apt-get install -y software-properties-common ca-certificates curl
  run sudo add-apt-repository -y universe
  run sudo add-apt-repository -y ppa:avengemedia/danklinux
  run sudo add-apt-repository -y ppa:avengemedia/dms
  run sudo apt-get update

  mapfile -t required_packages < <(package_names "$repo_dir/bootstrap/packages-ubuntu.txt")
  run sudo apt-get install -y "${required_packages[@]}"

  mapfile -t optional_packages < <(package_names "$repo_dir/bootstrap/packages-ubuntu-optional.txt")
  local available_packages=()
  local missing_packages=()
  local package
  for package in "${optional_packages[@]}"; do
    if $dry_run || apt-cache show "$package" >/dev/null 2>&1; then
      available_packages+=("$package")
    else
      missing_packages+=("$package")
    fi
  done
  if ((${#available_packages[@]})); then
    run sudo apt-get install -y "${available_packages[@]}"
  fi
  if ((${#missing_packages[@]})); then
    printf 'Optional Ubuntu packages unavailable and skipped: %s\n' "${missing_packages[*]}"
  fi
}

install_codex_cli() {
  if command -v codex >/dev/null 2>&1; then
    printf 'Codex is already installed; leaving the existing installation in place.\n'
    return
  fi

  if $dry_run; then
    printf '+ download and run the official Codex installer from https://chatgpt.com/codex/install.sh\n'
    return
  fi

  local installer
  installer="$(mktemp)"
  trap 'rm -f -- "$installer"' EXIT
  curl -fsSL https://chatgpt.com/codex/install.sh -o "$installer"
  CODEX_NON_INTERACTIVE=1 sh "$installer"
  rm -f -- "$installer"
  trap - EXIT
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

link_command_compatibility() {
  local local_bin="$HOME/.local/bin"
  run mkdir -p "$local_bin"
  if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
    link_item "$(command -v fdfind)" "$local_bin/fd"
  fi
  if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
    link_item "$(command -v batcat)" "$local_bin/bat"
  fi
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

  local item
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
  install_ubuntu_packages
  link_command_compatibility
fi

if $install_codex; then
  install_codex_cli
fi

if $link_configs; then
  install_configs
fi

if $install_packages && ! $dry_run; then
  sudo systemctl enable NetworkManager.service >/dev/null 2>&1 || true
  sudo systemctl enable bluetooth.service >/dev/null 2>&1 || true
fi

printf '\nUbuntu bootstrap complete.\n'
printf 'Next: install the official ChatGPT .deb, select Hyprland at login, run `dms doctor`, and open Neovim once.\n'
printf 'For Codex, run `codex` in Ghostty and choose Sign in with ChatGPT.\n'
if [[ "${SHELL:-}" != */zsh ]]; then
  printf 'Optional: set Zsh as your login shell with `chsh -s /usr/bin/zsh`.\n'
fi
