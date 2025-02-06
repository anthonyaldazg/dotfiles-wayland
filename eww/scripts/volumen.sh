#!/bin/bash
# Instalar jq: sudo pacman -S jq
get_vol () {
	volumen=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%.0f\n", $2 * 100}')
	echo "${volumen}"
}

get_icon () {
	echo "scripts/images/$( [[ $(get_vol) == "0%" || $(get_vol) == "muted" ]] && echo "mute" || echo "volume" ).png"
}

case "$1" in
    -v) get_vol ;;
    -i) get_icon ;;
esac
