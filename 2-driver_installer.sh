#!/bin/sh

#installs legacy drivers

unzip legacy_driver_bundle.zip
cd legacy_driver_bundle
sudo dpkg -i *.deb
sudo apt-get install -f -y
sudo /etc/init.d/udev restart

echo "Reboot to secure changes"
