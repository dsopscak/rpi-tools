#!/usr/bin/env bash

HOSTNAME=$1
PUB_KEY=$2

echo "Setup running for $HOSTNAME"

sudo cp -p /etc/hosts /etc/hosts.orig
sudo sed -i "s/raspberrypi/$HOSTNAME/g" /etc/hosts
sudo cp -p /etc/hostname /etc/hostname.orig
sudo sed -i "s/raspberrypi/$HOSTNAME/g" /etc/hostname
sudo cp -p /etc/locale.gen /etc/locale.gen.orig
sudo sed -i 's/^# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo sed -i 's/^en_GB.UTF-8 UTF-8/# en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen

echo -e "zoopi\nzoopi" | sudo passwd pi

mkdir ~/.ssh
echo $PUB_KEY >~/.ssh/authorized_keys
chmod 600 .ssh/authorized_keys
