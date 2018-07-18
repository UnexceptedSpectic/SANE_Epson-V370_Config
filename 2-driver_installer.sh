#!/bin/sh

#installs legacy drivers

unzip new_drivers_07182018.zip
sudo dpkg -i iscan_2.30.2-2_amd64.deb
sudo apt-get install -f -y
sudo dpkg -i iscan-data_1.36.0-1_all.deb
sudo apt-get install -f -y
sudo dpkg -i iscan-plugin-perfection-v370_1.0.0-2_amd64.deb
sudo apt-get install -f -y

sudo /etc/init.d/udev restart

echo "Reboot to secure changes"
