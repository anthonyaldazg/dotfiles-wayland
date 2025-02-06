#!/bin/bash
is_online()
{
	ping -c 1 -W 1 archlinux.org &>/dev/null
}
estado="Desconectado"
interface=$(ip link | awk '/state UP/ {print $2}' | tr -d :)
icono="scripts/images/no-wifi.png"

if is_online; then
	icono="scripts/images/wifi.png"
	estado="$interface"
fi

case "$1" in
    -e) echo "$estado" ;;
    -i) echo "$icono" ;;
esac

