#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
source_settings="$config_home/DankMaterialShell/settings.json"
source_plugins="$config_home/DankMaterialShell/plugin_settings.json"

if ! command -v jq >/dev/null 2>&1; then
  printf 'jq is required. Install it with: sudo pacman -S jq\n' >&2
  exit 1
fi

if [[ ! -f "$source_settings" || ! -f "$source_plugins" ]]; then
  printf 'DMS settings were not found under %s/DankMaterialShell.\n' "$config_home" >&2
  exit 1
fi

sanitize='def scrub_secrets:
  walk(if type == "object" then with_entries(if (.key | ascii_downcase | test("(apikey|api_key|token|secret|password)$")) then .value = "" else . end) else . end);
def scrub_absolute_paths:
  walk(if type == "string" and (startswith("/home/") or startswith("/mnt/")) then "" else . end);
del(
  .activeDisplayProfile,
  .displayProfiles,
  .hyprlandOutputSettings,
  .niriOutputSettings,
  .enabledGpuPciIds,
  .selectedGpuIndex,
  .systemMonitorGpuPciId,
  .browserUsageHistory,
  .filePickerUsageHistory,
  .greeterWallpaperPath,
  .lockScreenVideoPath,
  .lockScreenWallpaperPath,
  .dockLauncherLogoCustomPath,
  .launcherLogoCustomPath
) | scrub_secrets | scrub_absolute_paths'

jq --sort-keys "$sanitize" "$source_settings" > "$repo_dir/DankMaterialShell/settings.portable.json"
jq --sort-keys "$sanitize" "$source_plugins" > "$repo_dir/DankMaterialShell/plugin_settings.portable.json"

printf 'Updated portable DMS settings. Review the git diff before committing.\n'
