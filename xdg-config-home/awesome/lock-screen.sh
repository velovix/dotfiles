#!/bin/bash
ICON=$HOME/pictures/lock-icon.png
SCREENSHOT=/tmp/screen.png
import -window root -crop 1600x900+0+0 -quality 100 $SCREENSHOT
convert $SCREENSHOT -scale 10% -scale 1000% -modulate 70,100,100 $SCREENSHOT
convert $SCREENSHOT $ICON -gravity center -composite -matte $SCREENSHOT
i3lock -i $SCREENSHOT -c 000000
