#!/bin/bash
# Copies Omarchy's generated Vesktop theme into place, with the current font.
source="$HOME/.local/state/omarchy/current/theme/vesktop.css"
target="$HOME/.config/vesktop/themes/omarchy.css"
[[ -f $source ]] || exit 0
mkdir -p "${target%/*}"
font=$(omarchy font current 2>/dev/null)
radius=$(hyprctl getoption decoration:rounding -j 2>/dev/null | jq -r '.int // empty')
sed -e "s|__OMARCHY_FONT__|${font:-monospace}|g" -e "s|__OMARCHY_RADIUS__|${radius:-0}|g" "$source" > "$target.tmp" && mv "$target.tmp" "$target"
