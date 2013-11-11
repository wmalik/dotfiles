#!/bin/bash
# This script would show a notification if the battery is below $BAT_THRESHOLD
BAT_THRESHOLD=10
SUCCES=0

Percent=`acpi | awk '{print $4}' | sed "s/[%,]//g"`
if [ $Percent -le $BAT_THRESHOLD ]; then
    notify-send "Battery low"
fi
exit $SUCCESS
