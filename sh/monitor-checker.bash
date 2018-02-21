#!/usr/bin/env bash

export LAST_SETTING=""

LINE_COUNT=$(xrandr | grep "HDMI-0 connected" | wc -l)

if [ "$LINE_COUNT" == 1 ] && [ "$LAST_SETTING" != "external" ]
then
	LAST_SETTING="external"

	xrandr --output eDP-1-1 --dpi 96 --auto \
		--output HDMI-0 --dpi 96 --primary --right-of eDP-1-1 --auto
elif [ "$LINE_COUNT" == 0 ] && [ "$LAST_SETTING" != "no external" ]
then
	LAST_SETTING="no external"

	xrandr --output eDP-1-1 --dpi 96 --primary --auto \
		--output HDMI-0 --off
fi
