#!/bin/sh
set -e
#script to set up environment for sane and epson v370

#install required packages
sudo apt-get update & sudo apt-get upgrade -y
sudo apt-get install sane gcc make zip -y

#configure scanner driver
sudo echo 'epkowa' >> /etc/sane.d/dll.conf

#symlink drivers to the directory sane searches
sudo ln -s /usr/lib/sane/libsane-epkowa.so.1  /usr/lib/x86_64-linux-gnu/sane/libsane-epkowa.so.1 
sudo ln -s /usr/lib/sane/libsane-epkowa.la /usr/lib/x86_64-linux-gnu/sane/libsane-epkowa.la
sudo ln -s /usr/lib/sane/libsane-epkowa.so.1.0.15 /usr/lib/x86_64-linux-gnu/sane/libsane-epkowa.so.1.0.15

#permissions. allowing sane-find-scanner to work without sudo
sudo echo '# Epson Perfection V37 Photo' >> /lib/udev/rules.d/40-libsane.rules
sudo echo 'ATTRS{idVendor}=="04b8", ATTRS{idProduct}=="014a", ENV{libsane_matched}="yes"' >> /lib/udev/rules.d/40-libsane.rules
sudo echo 'ATTRS{idVendor}=="04a9", ATTRS{idProduct}=="1907", ENV{libsane_matched}="yes"' >> /lib/udev/rules.d/40-libsane.rules

sudo usermod -aG saned pbadzuh #replace pbadzuh with your username
sudo usermod -aG scanner pbadzuh

sudo echo '# usb scanner' > /etc/udev/rules.d/30-scanner-permissions.rules
sudo echo 'SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", MODE:="0666"' >> /etc/udev/rules.d/30-scanner-permissions.rules
sudo echo 'SUBSYSTEM=="usb_device",MODE:="0666"' >> /etc/udev/rules.d/30-scanner-permissions.rules

sudo chmod a+w /dev/bus/usb/*

#creating symlinks for the scanners. formatted for UnixScanningManager script to work with scanners
sudo echo 'ATTR{product}=="CanoScan",SYMLINK+="bus/usb/00%s{busnum}/NQBSCANNER%k"' > /etc/udev/rules.d/10-NQB.rules
sudo echo 'ATTR{product}=="EPSON Perfection V37/V370", SYMLINK+="bus/usb/00%s{busnum}/NQBSCANNER%k"' >> /etc/udev/rules.d/10-NQB.rules

#prevent usb autosuspend/sleep
sudo sed -i '/GRUB_CMDLINE_LINUX_DEFAULT/d' /etc/default/grub
sudo echo 'GRUB_CMDLINE_LINUX_DEFAULT="usbcore.autosuspend=-1"' >>  /etc/default/grub
sudo update-grub
