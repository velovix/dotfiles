#!/bin/bash

xfconf-query -c xfce4-session -p /sessions/Failsafe/Client0_Command -t string -sa $HOME/dotfiles/start_awesome_xfce.bash

