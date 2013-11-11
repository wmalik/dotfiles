#!/bin/bash
# start a coutdown

if [ $# -ne 1 ]
then
    echo "Usage: $0 time_in_seconds"; exit 1;
fi

SECONDS=$1

for n in `seq $SECONDS -1 1`; do
    notify-send -t 1000 $n; sleep 1;
done
