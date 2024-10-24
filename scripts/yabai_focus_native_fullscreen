#!/bin/sh
fullscreen_displays=$(yabai -m query --spaces | jq -c 'map(select(."is-native-fullscreen" == true))')

if [ $(echo $fullscreen_displays | jq 'length') -gt 0 ]; then
	# This should be at max length 1. Though this may likely break in a multimonitor environment
	visible_fullscreen_displays=$(echo $fullscreen_displays | jq -c 'map(select(."is-visible" == true))')

	goto_first_fs=false
	if [ $(echo $visible_fullscreen_displays | jq 'length') -gt "0" ]; then
		visible_id=$(echo $visible_fullscreen_displays | jq -c '.[0].index')
		next_index=$(($visible_id + 1))
		if [ $(echo $fullscreen_displays | jq "map(select(.index == $next_index)) | length") -gt "0" ]; then
			yabai -m space --focus $next_index
		else
			goto_first_fs=true
		fi
	else
		goto_first_fs=true
	fi

	if $goto_first_fs; then
		yabai -m space --focus $(echo $fullscreen_displays | jq 'sort_by(.index) | .[0].index')
	fi
else
	yabai -m space --focus 1
fi