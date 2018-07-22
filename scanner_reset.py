#!/usr/bin/python3
import os


bus_object=os.popen("lsusb | grep Epson | awk '{print $2}'")
bus=bus_object.read().split()[0]

device_object=os.popen("lsusb |grep Epson | awk '{print $4}'")
device=device_object.read().split()[0][0:-1]

os.system("sudo ./usbreset /dev/bus/usb/%s/%s"%(bus,device))
