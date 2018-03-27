#!/bin/bash

mkdir -p $HOME/.config

ln -s $PWD/xdg-config-home/nvim $HOME/.config/nvim
ln -s $PWD/xdg-config-home/awesome $HOME/.config/awesome
ln -s $PWD/xdg-config-home/compton.conf $HOME/.config/compton.conf
ln -s $PWD/xdg-config-home/kitty $HOME/.config/kitty
ln -s $PWD/xdg-config-home/lxterminal $HOME/.config/lxterminal
ln -s $PWD/xdg-config-home/systemd $HOME/.config/systemd
ln -s $PWD/sh $HOME/sh

ln -s $PWD/zshrc $HOME/.zshrc
ln -s $PWD/direnvrc $HOME/.direnvrc

ln -s $PWD/xdg-config-home/awesome/awesome.battery-widget/battery-widget.lua \
	$PWD/xdg-config-home/awesome/.
ln -s $PWD/xdg-config-home/awesome/awesome.brightness-widget/brightness-widget.lua \
	$PWD/xdg-config-home/awesome/.
ln -s $PWD/xdg-config-home/awesome/awesome.volume-widget/volume-widget.lua \
	$PWD/xdg-config-home/awesome/.
