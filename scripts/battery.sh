#!/bin/bash
# This script shows a notification if the battery is below $BAT_THRESHOLD
#BAT_THRESHOLD=15
BAT_THRESHOLD=$1
SUCCESS=0

Percent=`acpi | awk '{print $4}' | sed "s/[%,]//g"`
if [ $Percent -le $BAT_THRESHOLD ]; then
    (echo "Battery low"; sleep 2) | dzen2 -bg darkred -fg grey80
    echo "0 blink" > /proc/acpi/ibm/led
fi
exit $SUCCESS
