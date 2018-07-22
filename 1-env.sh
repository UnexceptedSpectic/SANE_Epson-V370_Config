#!/bin/sh
set -e
#script to set up environment for sane and epson v370

#install required packages
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install sane sane-utils libsane-extras gcc make zip ssmtp -y

#compile script that deals with hung-up usbs
sudo gcc usbreset.c -o usbreset
sudo chmod +x usbreset

#configure scanner driver
sudo echo 'epkowa' >> /etc/sane.d/dll.conf

#SANE config
sudo echo '# Epson Perfection V37 Photo' >> /lib/udev/rules.d/40-libsane.rules
sudo echo 'ATTRS{idVendor}=="04b8", ATTRS{idProduct}=="014a", ENV{libsane_matched}="yes"' >> /lib/udev/rules.d/40-libsane.rules

sudo usermod -aG saned pbadzuh #replace pbadzuh with your username
sudo usermod -aG scanner pbadzuh

#permissions. allowing sane-find-scanner to work without sudo
sudo echo '# usb scanner' > /etc/udev/rules.d/30-scanner-permissions.rules
sudo echo 'SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", MODE:="0666"' >> /etc/udev/rules.d/30-scanner-permissions.rules
sudo echo 'SUBSYSTEM=="usb_device", MODE:="0666"' >> /etc/udev/rules.d/30-scanner-permissions.rules

#creating symlinks for the scanners. formatted for UnixScanningManager script to work with scanners
sudo echo 'ATTR{product}=="EPSON Perfection V37/V370", SYMLINK+="bus/usb/00%s{busnum}/NQBSCANNER%k"' >> /etc/udev/rules.d/10-NQB.rules

#create directory to store scans
mkdir /home/pbadzuh/scans