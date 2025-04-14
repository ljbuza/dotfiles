#!/bin/sh
set -x

current_session=$XDG_CURRENT_DESKTOP

set_wallpaper_xfce() {
  dir="${HOME}/.local/share/walls"
  monitor="$(xrandr --query | grep " connected" | cut -d" " -f1)"
  BG=$(find "$dir" -type f -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" | shuf -n1)
  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor"$monitor"/workspace0/last-image -s "${BG}"
}

set_wallpaper_hyprland() {
  dir="${HOME}/Pictures/wallpapers"
  BG="$(find "$dir" -name '*.jpg' -o -name '*.png' | shuf -n1)"
  PROGRAM="swww-daemon"
  trans_type="simple"

  if pgrep "$PROGRAM" >/dev/null; then
    swww img "$BG" --transition-fps 244 --transition-type $trans_type --transition-duration 1
  else
    swww init && swww img "$BG" --transition-fps 244 --transition-type $trans_type --transition-duration 1
  fi

  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/swww/wallpapers"
  local filename = $(basename "$BG")

  # Create cache directory if it doesn't exist
  mkdir -p "$cache_dir"

  # Generate cached versions of the wallpaper
  if [ ! -f "${cache_dir}/${BG}.thumb" ]; then
    magick "${BG}"[0] -strip -thumbnail 500x500^ -gravity center -extent 500x500 "${cache_dir}/${filename}.thumb" &
  fi

  if [ ! -f "${cache_dir}/${BG}.rofi" ]; then
    magick "${BG}"[0] -strip -resize 2000 -gravity center -extent 2000 -quality 90 "${cache_dir}/${filename}.rofi" &
  fi

  if [ ! -f "${cache_dir}/${BG}.blur" ]; then
    magick "${BG}"[0] -strip -scale 10% -blur 0x3 -resize 100% "${cache_dir}/${filename}.blur" &
  fi

  wait

  ln -fs "${BG}" "${XDG_CONFIG_HOME:-$HOME/.config}/swww/wall.set"
  ln -fs "${cache_dir}/${filename}.rofi" "${XDG_CONFIG_HOME:-$HOME/.config}/swww/wall.rofi"
  ln -fs "${cache_dir}/${filename}.blur" "${XDG_CONFIG_HOME:-$HOME/.config}/swww/wall.blur"

}

set_wallpaper_other() {
  dir="${HOME}/.local/share/walls"
  BG="$(find "$dir" -name '*.jpg' -o -name '*.png' | shuf -n1)"
  cat "$BG" >~/.local/share/walls/wallpaper.jpg
  xwallpaper --zoom "$BG"
}

case "$current_session" in
"XFCE")
  set_wallpaper_xfce
  ;;
"Hyprland")
  set_wallpaper_hyprland
  ;;
*)
  set_wallpaper_other
  ;;
esac
