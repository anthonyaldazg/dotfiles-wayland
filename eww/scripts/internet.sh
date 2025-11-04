#!/bin/bash
interface=$(ip link | awk '/state UP/ {print $2}' | tr -d :)

# Si no usar ping con > dev/null EWW no podra cargar el ícono
if ping -c 4 -W 3 8.8.8.8 > /dev/null; then
	icono="scripts/images/wifi.png"
else
	icono="scripts/images/no-wifi.png"
fi

case "$1" in
	-in) echo "$interface" ;;
	-i) echo "$icono" ;;
esac
