#!/bin/bash
# Copies Omarchy's generated Vesktop theme into place, with the current font and corners.
source="$HOME/.local/state/omarchy/current/theme/vesktop.css"
target="$HOME/.config/vesktop/themes/omarchy.css"
[[ -f $source ]] || exit 0
mkdir -p "${target%/*}"
font=$(omarchy font current 2>/dev/null)
radius=$(hyprctl getoption decoration:rounding -j 2>/dev/null | jq -r '.int // empty')
# Hyprland power 1 gives straight chamfers; higher powers give rounded corners.
corner_shape=$(hyprctl getoption decoration:rounding_power -j 2>/dev/null | jq -r 'if .float == 1 then "bevel" else "round" end')
corner_scale=1
[[ $corner_shape == bevel ]] && corner_scale=0.5
sed -e "s|__OMARCHY_FONT__|${font:-monospace}|g" -e "s|__OMARCHY_RADIUS__|${radius:-0}|g" -e "s|__OMARCHY_CORNER_SHAPE__|${corner_shape:-round}|g" -e "s|__OMARCHY_CORNER_SCALE__|$corner_scale|g" "$source" > "$target.tmp" && mv "$target.tmp" "$target"
