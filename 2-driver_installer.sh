#!/bin/sh

#installs legacy drivers

unzip new_drivers_07182018.zip
sudo dpkg -i *.deb
sudo apt-get install -f -y

sudo /etc/init.d/udev restart

echo
echo "Reboot to secure changes"
