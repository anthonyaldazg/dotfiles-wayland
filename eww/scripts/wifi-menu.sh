#!/bin/bash

# Listar AP's disponibles/SSID's
Lista_De_PA=$(nmcli --fields "SSID" d wifi list | grep -v "SSID")

# Lista de AP's guardados
Lista_De_PA_Conocidos=$(nmcli -t -f NAME connection show)

# Estado del WIFI, es decir, si está activado o no
Estado_Del_WIFI=$(nmcli -fields WIFI g status | tail -n1 | tr -d ' ')

# Obtener SSID de la red a la que estamos conectados actualmente
SSID_De_PA_Actual=$(nmcli -f NAME connection show --active | sed -n '2p')

# "$Estado_Del_WIFI" es igual a "enabled" si tu SO usa como idioma el inglés
if [[ "$Estado_Del_WIFI" = "activado" ]]; then
    cambiador="Desactivar WIFI"
elif [[ "$Estado_Del_WIFI" = "desactivado" ]]; then
    cambiador="Activar WIFI"
fi

wofi_menu=$(echo -e "$cambiador\nConexión manual\n$Lista_De_PA\nGenerar QR de PA actual" | uniq -u | wofi -o HDMI-A-1 -d -p "Seleccione un PA:" -W 320 -H 400 -l 1 | sed 's/\s\{2,\}/\n/g' | awk -F "\n" '{print $1}')

# Si el usuario selecciona la opción "Manual" en el anterior menú, verá este menú:
if [ -z "$wofi_menu" ]; then
	exit 0
elif [ "$wofi_menu" = "Conexión manual" ]; then
	fyi "wifi menu" "Ingrese el SSID"
	SSID=$(wofi -o HDMI-A-1 -d -W 320 -H 400 -l 1)
	if [ -z "$SSID" ]; then
		exit 0
	else
		fyi "wifi menu" "Ingrese la contraseña"
		clave=$(wofi -o HDMI-A-1 -d -W 320 -H 400 -l 1)
		# si la longitud de $clave es cero el script se cerrará
		if [ -z "$clave" ]; then
			exit 0
		else
			nmcli d wifi connect "$SSID" password "$clave"
			fyi -i $HOME/.config/mako/images/router.png -t 10000 "Punto de acceso guardado" "No es necesario escribir la contraseña del punto de acceso la próxima vez"
		fi
	fi
elif [ "$wofi_menu" = "Activar WIFI" ]; then
	nmcli radio wifi on
elif [ "$wofi_menu" = "Desactivar WIFI" ]; then
	nmcli radio wifi off
elif [ "$wofi_menu" = "Generar QR de PA actual" ]; then
	# definir reglas en su compositor wayland, en mi caso defino esto en Wayfire:
	# kitty3=on created if app_id is "QR" then set geometry 1520 0 400 400
	# kitty4=on created if app_id is "QR" then set alpha 0.7
	# \n es igual a dar un enter, de forma q ejecuta el comando
	kitty --class QR --title PA -e zsh -c 'nmcli dev wifi show; exec zsh'
	# grep -q es modo silencioso
elif echo "$Lista_De_PA_Conocidos" | grep -xq "^$wofi_menu$"; then
	nmcli c up "$wofi_menu"
	if [ -f "$HOME/.config/eww/scripts/sonidos/moneda_de_mario_con_silencio.mp3" ]; then 
		if ! pgrep -x "ffplay" > /dev/null; then
			fyi -i $HOME/.config/mako/images/router.png -t 10000 "Punto de acceso antes guardado" "No es necesario escribir la contraseña"
			ffplay -nodisp -autoexit -probesize 32 -analyzeduration 0 $HOME/.config/eww/scripts/sonidos/moneda_de_mario_con_silencio.mp3
		fi
	else
		ffmpeg -i $HOME/.config/eww/scripts/sonidos/moneda_de_mario.mp3 -af "adelay=1000|1000" $HOME/.config/eww/scripts/sonidos/moneda_de_mario_con_silencio.mp3
		if ! pgrep -x "ffplay" > /dev/null; then
			fyi -i $HOME/.config/mako/images/router.png -t 10000 "Punto de acceso antes guardado" "No es necesario escribir la contraseña"
			ffplay -nodisp -autoexit -probesize 32 -analyzeduration 0 $HOME/.config/eww/scripts/sonidos/moneda_de_mario_con_silencio.mp3	
		fi
	fi
else
	BSSID_scan=$(nmcli -f SSID,BSSID dev wifi list | grep "$wofi_menu" | sed -n 's/.*\(..\:..\:..\:..\:..\:..\).*/\1/p')
	fyi -i $HOME/.config/mako/images/no_router.png -t 5000 "Punto de acceso no guardado" "Escribe la contraseña"
	clave=$(wofi -o HDMI-A-1 -d -W 320 -H 400 -l 1)
	# Si el usuario no ha introducido una contraseña se termina el script
	# Si el ususario introduce una contraseña usamos la contraseña para nmcli
	if [ -z "$clave" ]; then
		exit 0
	else
		nmcli d wifi connect "$BSSID_scan" password "$clave"
		fyi -i $HOME/.config/mako/images/router.png -t 10000 "Punto de acceso guardado" "No es necesario escribir la contraseña del punto de acceso la próxima vez"
	fi
fi
