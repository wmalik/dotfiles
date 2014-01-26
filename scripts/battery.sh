#!/bin/bash
# This script shows a notification if the battery is below $BAT_THRESHOLD
BAT_THRESHOLD=5
SUCCES=0

Percent=`acpi | awk '{print $4}' | sed "s/[%,]//g"`
if [ $Percent -le $BAT_THRESHOLD ]; then
    (echo "Battery low"; sleep 2) | dzen2 -bg darkred -fg grey80
fi
exit $SUCCESS
