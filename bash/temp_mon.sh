#!/usr/bin/env bash

if [[ -z "$1" ]]; then
    gap=10
else
    gap=$1
fi

while true; do
    vcgencmd measure_temp
    vcgencmd get_throttled
    sleep $gap
done
