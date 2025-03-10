#!/bin/bash
# mako
wal -q -n -i Fondos/casio-00.png
cp $HOME/.cache/wal/mako_config $HOME/.config/mako/config
makoctl reload
#
# EWW
eww open bar
#
# swaybg
swaybg -o eDP-1 -i $HOME/Fondos/4chan-00.png -m fit -c "#d4eeee" -o HDMI-A-1 -i $HOME/Fondos/casio-00.png -m fit -c "#ffffff"
#
