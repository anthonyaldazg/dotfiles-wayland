#!/usr/bin/env bash
# sudo pacman -S python-gtts ffmpeg

c=$(cat /sys/class/power_supply/BAT0/capacity)
s=$(cat /sys/class/power_supply/BAT0/status)

if [ $c -lt 30 ] && [ $s = "Discharging" ]; then
	gtts-cli -o $HOME/.config/eww/scripts/sonidos/bateria_baja.mp3 -l es 'ADVERTENCIA: BATERÍA BAJA. Conecte el cargador.'
	if [ -f "$HOME/.config/eww/scripts/sonidos/bateria_baja_con_silencio.mp3" ]; then
		# con este condicional me aseguro q primero termine algún ffplay anterior
		# ya que como esto esta en constante ejecución entra en bucle
		# Sin este condicional se superponen las voces
		if ! pgrep -x "ffplay" > /dev/null; then
			ffplay -nodisp -autoexit -probesize 32 -analyzeduration 0 $HOME/.config/eww/scripts/sonidos/bateria_baja_con_silencio.mp3
		fi
	else
		# convertimos el audio bateria-baja.mp3 a uno con silencio al inicio
		ffmpeg -i $HOME/.config/eww/scripts/sonidos/bateria_baja.mp3 -af "adelay=1000|1000" $HOME/.config/eww/scripts/sonidos/bateria_baja_con_silencio.mp3
                if ! pgrep -x "ffplay" > /dev/null; then
			ffplay -nodisp -autoexit -probesize 32 -analyzeduration 0 $HOME/.config/eww/scripts/sonidos/bateria_baja_con_silencio.mp3
		fi
	fi
	fyi --hint=string:x-canonical-private-synchronous:bateria_baja -i $HOME/.config/eww/scripts/images/battery-low.png 'ADVERTENCIA: BATERÍA BAJA' 'Conecte el cargador'
else
	if [ $c -gt 25 ] && [ $c -lt 30 ] && [ $s = "Charging" ]; then
		fyi --hint=string:x-canonical-private-synchronous:bateria_baja -i $HOME/.config/eww/scripts/images/battery-low.png 'CARGANDO BATERÍA' 'Cargador conectado'
	fi
fi

icon() {
if [ "$c" -eq 100 ]; then
	echo "󰂄"
elif [ "$c" -le 10 ]; then
	echo "󰁺"
elif [ "$c" -le 20 ]; then
	echo "󰁻"
elif [ "$c" -le 30 ]; then
	echo "󰁼"
elif [ "$c" -le 40 ]; then
	echo "󰁽"
elif [ "$c" -le 50 ]; then
	echo "󰁾"
elif [ "$c" -le 60 ]; then
	echo "󰁿"
elif [ "$c" -le 70 ]; then
	echo "󰂀"
elif [ "$c" -le 80 ]; then
	echo "󰂁"
elif [ "$c" -le 90 ]; then
	echo "󰂂"
elif [ "$c" -le 99 ]; then
	echo "󱧥 "
else
	echo "󰂃"
fi
}

[ "$1" = "-i" ] && icon && exit
[ "$1" = "-p" ] && cat /sys/class/power_supply/BAT0/capacity && exit
