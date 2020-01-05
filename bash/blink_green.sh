#!/usr/bin/env bash

trigger_file=/sys/class/leds/led0/trigger
lite_file=/sys/class/leds/led0/brightness
gap='.5'

echo none | sudo tee $trigger_file
for i in {1..10}; do
    echo 1 | sudo tee $lite_file
    sleep $gap
    echo 0 | sudo tee $lite_file
    sleep $gap
done
echo mmc0 | sudo tee $trigger_file
