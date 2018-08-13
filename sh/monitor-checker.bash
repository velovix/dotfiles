#!/usr/bin/env bash

export LAST_SETTING=""

LINE_COUNT=$(xrandr | grep "HDMI-0 connected" | wc -l)

echo "Line count is $LINE_COUNT"

if [ "$LINE_COUNT" == 1 ] && [ "$LAST_SETTING" != "external" ]
then
	echo "Swiching to external"
	LAST_SETTING="external"

	xrandr --output eDP-1-1 --dpi 96 --auto \
		--output HDMI-0 --dpi 96 --primary --right-of eDP-1-1 --auto \
		--output DP-0 --dpi 96 --right-of HDMI-0 --auto
elif [ "$LINE_COUNT" == 0 ] && [ "$LAST_SETTING" != "no external" ]
then
	echo "Switching to no-external"
	LAST_SETTING="no external"

	xrandr --output eDP-1-1 --dpi 96 --primary --auto \
		--output HDMI-0 --off
else
	echo "Doing nothing for some reason"
fi
