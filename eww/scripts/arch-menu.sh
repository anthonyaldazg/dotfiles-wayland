#!/bin/bash

icon () {
	echo "scripts/images/arch.svg"
}

launcher () {
	wofi --show drun --style $HOME/.config/eww/scripts/arch-menu-theme.scss
}

case "$1" in
	-i) icon ;;
	-l) launcher ;;
esac
