#!/usr/bin/env bash
#
# cluster_main.sh
#
# Run first to setup a main, master node of a cluster. Sets up
# dnsmasq-based dns and dhcpd services for additional, slave nodes
# that will be connected via wired ethernet. The "master" will also
# act as a router, providing access to whatever network is connected
# via wifi.
#
# Reboot needed after running this.

sudo apt update
sudo apt install -y dnsmasq sshpass

# Activate dhcpd facility on wired (eth0) interface
sudo cp -p /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
sudo sed -i 's/^#interface=/interface=eth0/' /etc/dnsmasq.conf
sudo sed -i '0,/^#dhcp-range=.*/s//dhcp-range=192.168.99.50,192.168.99.150,12h/' /etc/dnsmasq.conf

# Establish static address for wired (eth0) interface
sudo cp -p /etc/dhcpcd.conf /etc/dhcpcd.conf.orig
sudo sed -i '0,/^#interface eth0/s//interface eth0/' /etc/dhcpcd.conf
sudo sed -i 's/^#static ip_address=192.168.0.10\/24/static ip_address=192.168.99.1\/24/' /etc/dhcpcd.conf

# Sooper simple router between wired and wifi interfaces
sudo cp -p /etc/rc.local /etc/rc.local.orig
cat << 'EOF' | sudo tee /etc/rc.local
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

# Print the IP address
_IP=$(hostname -I) || true
if [ "$_IP" ]; then
  printf "My IP address is %s\n" "$_IP"
fi

echo 0 >/proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o wlan0 -s 192.168.99.0/24 -j MASQUERADE
echo 1 >/proc/sys/net/ipv4/ip_forward

exit 0
EOF

# Insure there is a default key pair for use with the slaves
cat /dev/zero | ssh-keygen -q -N ""

