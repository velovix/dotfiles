#!/bin/bash

mkdir -p $HOME/.config

ln -s $PWD/xdg-config-home/nvim $HOME/.config/nvim
ln -s $PWD/xdg-config-home/awesome $HOME/.config/awesome
ln -s $PWD/xdg-config-home/compton.conf $HOME/.config/compton.conf
ln -s $PWD/xdg-config-home/kitty $HOME/.config/kitty
ln -s $PWD/xdg-config-home/lxterminal $HOME/.config/lxterminal
ln -s $PWD/xdg-config-home/pacman $HOME/.config/pacman
ln -s $PWD/xdg-config-home/rofi $HOME/.config/rofi
ln -s $PWD/sh $HOME/sh

ln -s $PWD/zshrc $HOME/.zshrc
ln -s $PWD/direnvrc $HOME/.direnvrc
