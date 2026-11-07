#!/bin/bash
# Installs the Omarchy theme for Vesktop. Vesktop itself must be installed.
#   ./install.sh [--bar-icon] [--glow] [--no-apply]
set -euo pipefail

bar_icon=false glow=false apply=true
for arg in "$@"; do
  case "$arg" in
  --bar-icon) bar_icon=true ;;
  --glow) glow=true ;;
  --no-apply) apply=false ;;
  *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done

repo=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
config="${XDG_CONFIG_HOME:-$HOME/.config}"
state="${XDG_STATE_HOME:-$HOME/.local/state}"

mkdir -p "$config/omarchy/themed" "$config/omarchy/hooks/theme-set.d" "$config/omarchy/hooks/font-set.d" "$config/vesktop/settings"
cp "$repo/themed/vesktop.css.tpl" "$config/omarchy/themed/"
install -m 755 "$repo/hooks/vesktop-theme.sh" "$config/omarchy/hooks/theme-set.d/"
install -m 755 "$repo/hooks/vesktop-theme.sh" "$config/omarchy/hooks/font-set.d/"

# Turn the theme on without touching other Vencord settings.
settings="$config/vesktop/settings/settings.json"
[[ -s $settings ]] || echo '{}' > "$settings"
jq '.enabledThemes = ((.enabledThemes // []) + ["omarchy.css"] | unique)' "$settings" > "$settings.tmp"
mv "$settings.tmp" "$settings"

if $glow; then
  install -m 755 "$repo/hooks/hypr-glow.sh" "$config/omarchy/hooks/theme-set.d/"
  line='pcall(require, "hypr.glow")'
  grep -qF "$line" "$config/hypr/hyprland.lua" || printf '\n-- Window glow color, written by the hypr-glow theme hook.\n%s\n' "$line" >> "$config/hypr/hyprland.lua"
fi

if $bar_icon; then
  mkdir -p "$config/omarchy/plugins"
  cp -R "$repo/plugin/dev.tayters.discord" "$config/omarchy/plugins/"
  echo "Bar icon copied. Enable it with:"
  echo "  omarchy-shell shell rescanPlugins && omarchy plugin enable dev.tayters.discord --section right"
fi

# Re-applying the active theme generates the CSS and runs the hooks.
if $apply; then
  omarchy theme set "$(cat "$state/omarchy/current/theme.name")"
fi
echo "Done. Vesktop picks the theme up live."
