#!/bin/sh

#installs legacy drivers, confirmed to work on linux mint 16
unzip legacy_driver_bundle.zip
sudo dpkg -i *.deb
sudo apt-get install -f -y

#links drivers to appropriate folder
sudo ln -sfr /usr/lib/sane/libsane-epkowa* /usr/lib/x86_64-linux-gnu/sane/

sudo /etc/init.d/udev restart
sudo rm *.deb

echo "Reboot to secure changes"
