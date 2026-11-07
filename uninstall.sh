#!/bin/bash
# Removes everything install.sh added. Vesktop itself stays installed.
set -euo pipefail
config="${XDG_CONFIG_HOME:-$HOME/.config}"
rm -f "$config/omarchy/themed/vesktop.css.tpl" \
  "$config/omarchy/hooks/theme-set.d/vesktop-theme.sh" \
  "$config/omarchy/hooks/font-set.d/vesktop-theme.sh" \
  "$config/omarchy/hooks/theme-set.d/hypr-glow.sh" \
  "$config/vesktop/themes/omarchy.css" \
  "$config/hypr/glow.lua"
settings="$config/vesktop/settings/settings.json"
if [[ -f $settings ]]; then
  jq '.enabledThemes = ((.enabledThemes // []) - ["omarchy.css"])' "$settings" > "$settings.tmp" && mv "$settings.tmp" "$settings"
fi
if [[ -f $config/hypr/hyprland.lua ]]; then
  sed -i '/hypr-glow theme hook/d;/pcall(require, "hypr.glow")/d' "$config/hypr/hyprland.lua"
fi
if [[ -d $config/omarchy/plugins/dev.tayters.discord ]]; then
  omarchy plugin disable dev.tayters.discord 2>/dev/null || true
  rm -rf "$config/omarchy/plugins/dev.tayters.discord"
fi
echo "Removed."
