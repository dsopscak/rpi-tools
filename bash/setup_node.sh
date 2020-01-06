#!/usr/bin/env bash
#
# setup_node.sh <hostname> <public key>
#
# Assumes a file named 'secrets' is in the same directory as the
# script containing at least something like
#
#   PI_PASSWORD=new_pi_password
#
# Assumes running user has sudo permissions.
#
# Changes the hostname as given and adds the given public key to
# ~/.ssh/authorized_keys.

HOSTNAME=$1
PUB_KEY=$2

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
if [[ -f $DIR/secrets ]]; then
    . $DIR/secrets
fi
if [[ -z "$PI_PASSWORD" ]]; then
    echo "** FATAL: PI_PASSWORD not set. Insure a secrets file exists next"
    echo "** to this providing a new password for the pi user"
    exit -1
fi

echo "Setup running for $HOSTNAME"

sudo cp -p /etc/hosts /etc/hosts.orig
sudo sed -i "s/raspberrypi/$HOSTNAME/g" /etc/hosts
sudo cp -p /etc/hostname /etc/hostname.orig
sudo sed -i "s/raspberrypi/$HOSTNAME/g" /etc/hostname
sudo cp -p /etc/locale.gen /etc/locale.gen.orig
sudo sed -i 's/^# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo sed -i 's/^en_GB.UTF-8 UTF-8/# en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen

echo -e "$PI_PASSWORD\n$PI_PASSWORD" | sudo passwd $USER

mkdir -p ~/.ssh
echo $PUB_KEY >~/.ssh/authorized_keys
chmod 600 .ssh/authorized_keys
