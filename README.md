# rpi-tools

Dev-Opsy tools for working with Raspberry Pi computers.

## Scenario: Mini-Cluster Lab
You have some number N of Raspberry Pi computers you want to set up as a cluster of N-1 like-configured slaves on their own sub-network. The remaining Pi will be configured as a master providing controlled access to the cluster. Network connections between the Pi's will use their wired interface and the master will connect to the "outside" world using its wi-fi interface. The master will act as a router for the cluster, making the external network visible to the slaves.

The hardware needed, in addition to the Pi's themselves, includes:

* An ethernet hub or switch or combination thereof connected together providing enough ports for the computers.

* An ethernet cable for each computer.

* A power source and cable for each computer.

* A micro-sdhc card for each computer with a fresh raspbian image and ssh enabled.

* A monitor, keyboard, and mouse to connect to the master Pi.

* Some kind of cases or a mini rack to house the computers (not strictly needed but makes life much easier)

The images/create_raspbian_boot.ps1 script provides a minimal command line facility for writing raspbian images, with ssh enabled, using a windows computer.

Connect everything up but leave the power off on the slaves to start. Power up the master and run through the first boot setup, being sure to configure the wi-fi network. With initial setup complete, clone this repo on the master and run the bash/cluster_main.sh script. This script depends on default contents for the various system files it updates, so any manual configuration beyond that described above may cause it to malfunction. With that complete, a final reboot on the master is needed.

Apply power to the remaining Raspberry Pi's and wait for them all to complete their initial boot. It shouldn't take more than a few minutes and you should be able to tell by watching the green LED's. When they're ready, the green LED activity will be very low.

Run the bash/cluster_up.sh script on the master. This will automatically configure each slave, one at a time. The order will be indeterminate, however, so it will pause before each one and blink the green LED for ten seconds so you can tell which Pi is next. This allows you to supply the script with a suffix for the hostname that will be applied to that slave so you can tell what the name of each physical computer will be. The base name for each host will be "pi". You could, for example, use 01, 02, and 03 as the suffix for three slaves in a mini-rack, to name them pi01, pi02, and pi03, from top-to-bottom. Be careful entering the suffix, it's not very user-friendly and won't recover well from most mistakes.

When the process is complete you should be able to ssh from the master to all the slaves by name without needing passwords. A unique key-pair is generated for the cluster for communication between all the nodes.

This is a repeatable way to create a baseline cluster, to be further configured for whatever specialized purpose you may have in mind. If you screw it up, it can easily be re-provisioned using a fresh set of micro-sdhc cards.
