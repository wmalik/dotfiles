#!/bin/bash

files=($HOME/wallpapers/*)
wallpaper=`printf "%s\n" "${files[RANDOM % ${#files[@]}]}"`
feh --bg-scale $wallpaper
