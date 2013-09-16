#!/bin/bash

files=($HOME/wallpapers/*)
printf "%s\n" "${files[RANDOM % ${#files[@]}]}"
