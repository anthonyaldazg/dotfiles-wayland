#!/bin/bash
# sudo pacman -S jq wireplumber fyi
get_vol () {
	volumen=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%.0f\n", $2 * 100}')
	echo "${volumen}"
}

get_icon () {
	echo "scripts/images/$( [[ $(get_vol) == "0" || $(get_vol) == "muted" ]] && echo "mute" || echo "volume" ).png"
}

function send_notification {
	vol=$1
	# Make the bar with the special character ─ (it's not dash -)
	# https://en.wikipedia.org/wiki/Box-drawing_character
	bar=$(seq -s "─" 0 $((vol / 5)) | sed 's/[0-9]//g')
	# Send the notification
	fyi -t 3000 -p -i $HOME/.config/eww/scripts/images/volume.png -H string:x-canonical-private-synchronous:vol_noti -H int:value:$(($vol)) "Volumen" "$vol%" > /tmp/vol.txt
}

case "$1" in
	-v) get_vol ;;
	-i) get_icon ;;
	-n) send_notification $2 ;;
esac
