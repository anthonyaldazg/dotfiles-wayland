#!/bin/bash
hellwal -i ~/Descargas/Fondos/linux-girl-00.png --light --static-background "#000000" --static-foreground "#ffffff"; cp $HOME/.cache/hellwal/mako_config $HOME/.config/mako/config; makoctl reload

#Siempre usa swaybg al final porque si lo que este despues de el no se ejecutara
swaybg -o eDP-1 -c '#ffffff' -i ~/Descargas/Fondos/supermanPazEnLaTierra.png -m center -o HDMI-A-1 -c '#ffffff' -i ~/Descargas/Fondos/linux-girl-00.png -m fill

#swaybg -o HDMI-A-1 -c '#ffffff' -i ~/Descargas/Fondos/linux-girl-00.png -m fill
