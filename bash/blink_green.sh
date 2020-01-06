#!/usr/bin/env bash
#
# Blinks the green led for 10 seconds.

trigger_file=/sys/class/leds/led0/trigger
lite_file=/sys/class/leds/led0/brightness
count=10
gap='.5'

echo none | sudo tee $trigger_file >/dev/null
printf "$count seconds"
for i in $(seq $count); do
    printf "."
    echo 1 | sudo tee $lite_file >/dev/null
    sleep $gap
    echo 0 | sudo tee $lite_file >/dev/null
    sleep $gap
done
printf "done\n"
echo mmc0 | sudo tee $trigger_file >/dev/null
