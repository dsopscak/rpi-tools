#!/usr/bin/env bash
#
# temp_mon.sh [seconds]
#
# Display rpi temp sensor reading every so many seconds. Defaults to
# 10 seconds. <ctl>-c to stop.

if [[ -z "$1" ]]; then
    interval=10
else
    interval=$1
fi

while true; do
    vcgencmd measure_temp
    vcgencmd get_throttled
    sleep $interval
done
