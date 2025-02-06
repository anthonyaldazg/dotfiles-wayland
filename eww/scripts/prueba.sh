#!/bin/zsh
# Crear la ventana de kitty con la clase "QR" y el título "PA"
kitten @ launch --type os-window --os-window-class QR --title PA
# Esperar un momento para asegurarse de que la ventana se haya creado
sleep 1
# Enviar el comando a la ventana
# \n es igual a dar un enter, de forma q ejecuta el comando
kitten @ send-text --exclude-active -m title:PA "nmcli dev wifi show\n"
