#!/usr/bin/env bash
#
# cluster_up.sh
#
# Runs on the master node after completion of cluster_main.sh and
# reboot. Assumes the slaves are all connected to the wired (eth0)
# network and have completed the first boot of a stock raspbian image
# with ssh enabled. Assumes all necessary files are colocated with
# this script in the same directory to be copied to each target into
#
#   ~pi/rpi_tools
#
# Iterates over each ip address in the dhcpd lease file and flashes
# the green led to allow physical identification. Waits for input of a
# hostname suffix to make a unique name out of "pi" + $suffix (something
# like pi01). A blank suffix skips the host.
#
# If not skipped, setup_node.sh is invoked on the target: the host is
# renamed, the pi user's passwd changed to the $PI_PASSWORD value set
# in the secrets file, and the master's key is added to
# ~pi/.ssh/authorized_keys. Finally, the target host is rebooted.
# Also, the hostname is added to the master's hosts file which also
# makes it available to others on the wired network via DNS.

LEASE_FILE=/var/lib/misc/dnsmasq.leases
PUB_KEY=$(<~/.ssh/id_rsa.pub)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

function ssh_accept_host()
    {
    if [[ ! -d ~/.ssh ]]; then mkdir ~/.ssh; fi
    if [[ ! -f ~/.ssh/known_hosts ]]; then touch ~/.ssh/known_hosts; fi
    hostkeys=$(ssh-keyscan $1 2>/dev/null)
    keyline=$(echo "$hostkeys" | cut -d $'\n' -f 1) # single line easy grep
    if ! grep "$keyline" ~/.ssh/known_hosts >/dev/null; then
        echo "$hostkeys" >>~/.ssh/known_hosts
    fi
    }

for addr in $(cut -d ' ' -f 3 $LEASE_FILE); do
    echo '*****************'
    echo $addr
    ssh_accept_host $addr
    sshpass -p raspberry rsync -tpr $DIR/ pi@$addr:~/rpi_tools
    sshpass -p raspberry ssh pi@$addr ./rpi_tools/blink_green.sh
    echo "Enter hostname suffix:"
    read suffix
    if [[ -z "$suffix" ]]; then
        echo "Skipping $addr"
    else
        new_name=pi$suffix
        echo "Using $new_name as the hostname for $addr"
        # TODO: some sanity checking befor updating hosts file...
        echo "$addr $new_name" | sudo tee -a /etc/hosts
        ssh_accept_host $new_name
        hosts="$hosts $new_name"
        if sshpass -p raspberry ssh pi@$new_name ./rpi_tools/setup_node.sh $new_name "'$PUB_KEY'"; then
            ssh pi@$new_name sudo reboot
        fi
    fi
done

echo "ALL_HOSTS = %w[$hosts]" >>$HOME/.remote_cmd.config

sudo service dnsmasq restart # pick up any changes to /etc/hosts
