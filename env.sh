#!/bin/sh
#script to set up environment for ScanLag

sudo apt-get update & sudo apt-get upgrade -y
sudo apt-get install sane sanue-utils libsane-extras git

git clone https://github.com/UnexceptedSpectic/SANE_Epson-V370_Config.git

cd SANE_Epson-V370_Config

tar -xyf 07062018_driver_bundle.deb.tar.gz

cd iscan-perfection-v370-bundle-1.0.1.x64.deb

sudo ./install.sh

sudo "# Epson Perfection V37 Photo" >> /lib/udev/rules.d/40-libsane.rules
sudo "ATTRS{idVendor}=="04b8", ATTRS{idProduct}=="014a", NV{libsane_matched}="yes"" >> /lib/udev/rules.d/40-libsane.rules
sudo "ATTRS{idVendor}=="04a9", ATTRS{idProduct}=="1907", NV{libsane_matched}="yes"" >> /lib/udev/rules.d/40-libsane.rules

sudo usermod -aG saned $USER
sudo usermod -aG scanner $USER

sudo touch /etc/udev/rules.d/30-scanner-permissions.rules

sudo "# usb scanner" >> /etc/udev/rules.d/30-scanner-permissions.rules
sudo "SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", MODE:="0666"" >> /etc/udev/rules.d/30-scanner-permissions.rules
SUBSYSTEM=="usb_device",MODE:="0666"" >> /etc/udev/rules.d/30-scanner-permissions.rules

sudo chmod a+w /dev/bus/usb/*