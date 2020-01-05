#!/usr/bin/env bash

LEASE_FILE=/var/lib/misc/dnsmasq.leases
PUB_KEY=$(<~/.ssh/id_rsa.pub)

for addr in $(cut -d ' ' -f 3 $LEASE_FILE); do
    echo '*****************'
    echo $addr
    ssh-keyscan -H $addr >>~/.ssh/known_hosts
    sshpass -p raspberry scp -r rpi_tools $addr:~
    sshpass -p raspberry ssh $addr ./rpi_tools/blink_green.sh
    echo "Enter number wart:"
    read wart
    if [[ ! -z "$wart" ]]; then
        new_name=pi$wart
        echo "Using $new_name as the hostname for $addr"
        echo "$addr $new_name" | sudo tee -a /etc/hosts
        ssh-keyscan -H $new_name >>~/.ssh/known_hosts
        sshpass -p raspberry ssh $new_name ./rpi_tools/setup_node.sh $new_name "'$PUB_KEY'"
        ssh $new_name sudo reboot
    fi
done
