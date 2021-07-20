#!/bin/bash

# Run this command in order for Ubuntu to not use Super+# to be for the
# favorites bar, but for whatever I actually want it to do:
# https://askubuntu.com/questions/1160234/customize-super-n-behavior

# Then you have to do that for each number you want to override, 
# by changing "1" to the requisite digit

set -e
for NUMBER in 1 2 3 4
do 
	gsettings set org.gnome.shell.extensions.dash-to-dock app-hotkey-$NUMBER '[]'
	gsettings set org.gnome.shell.keybindings switch-to-application-$NUMBER '[]'
done

