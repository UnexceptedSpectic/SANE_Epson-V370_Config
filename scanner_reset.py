#!/usr/bin/python3
import os


bus=os.popen("lsusb | grep Epson | awk '{print $2}'").read().split('\n')[:-1]
device=os.popen("lsusb | grep Epson | awk '{print $4}'").read().split(':\n')[:-1]

for i in range(0,len(bus)):
    a=bus[i]
    b=device[i]
    os.system("sudo ./usbreset /dev/bus/usb/%s/%s" %(a,b))