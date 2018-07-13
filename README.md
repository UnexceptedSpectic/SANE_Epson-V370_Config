    #these instructions are for reference only. '1-env.sh' and '2-driver_installer.sh' automate this configuring the os and sane to work with multiple Epson v370 scanners. for any errors refer to the detailed steps and explanations below. confirmed to work on ubuntu server 18.04 LTS.

1) install sane.  
'sudo apt-get update & sudo apt-get upgrade -y'  
'sudo apt-get install sane'  

2) install epkowa drivers to ensure epson v370 support in sane  
#newest drivers  

    #download_search: http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX  

#confirmed working legacy drivers   

    #download link: https://goo.gl/tsnu23  

install all .deb files with: 'dpgk -i ./*.deb'  
if given dependency error, run for each driver:  
'sudo dpkg -i DRIVER.deb'  
'sudo apt-get install -f'  

3) run: 'sane-find-scanner'; if scanners are found, then they are sensed by the OS   
#'scanimage -L' will not identify scanners until their drivers are configured. drivers allow sane to work with them  

permissions issue - if 'sane-find-scanner' only runs when using sudo, follow guide at  

    #read more: https://help.ubuntu.com/community/SettingScannerPermissions  

4) add the driver to the list in /usr/local/etc/sane.d/dll.conf or /etc/sane.d/dll.conf: add the word 'epkowa' to the list  
run: 'scanimage -L' ## may require reboot  

*common issues/fixes; try rerunning 'scanimage -L' and rebooting between each fix:  

-run: 'export SANE_DEBUG_DLL="128 scanimage -L"' and then 'scanimage -L' for verbose output showing which drivers sane is trying to load. Locate the output line where sane searches for epkowa. If it is unable to find/initialize its drivers, note the DIRECTORY in which it searches for them and create sym link to them using 'sudo ln -s TARGET SYMLINK', where TARGET == /usr/lib/sane/DRIVER and SYMLINK is DIRECTORY/DRIVER  
#if installed drivers are not located in TARGET, run: 'sudo find / -iname '*libsane-epkowa*''  

-add usb to /etc/sane.d/epkowa.conf as described in https://help.ubuntu.com/community/sane in Installing your USB scanner  

run 'man sane' and read problems section for further troubleshooting  

5) Create fixed names for the scanners to ensure that after going to sleep and being remounted by the OS their names don't change. This relies on associating physical inputs of the computer with a mounted device name. This is done using udev  

run: 'sudo nano /etc/udev/rules.d/10-NQB.rules'   
add the lines:  
    ATTR{product}=="CanoScan",SYMLINK+="bus/usb/00%s{busnum}/NQBSCANNER%k"  
    ATTR{product}=="EPSON Perfection V37/V370", SYMLINK+="bus/usb/00%s{busnum}/NQBSCANNER%k"  
    
    #script takes care of creating symlinks for the epson scanners, so the below notes are simply fyi  

udev intro for beginners:  

    #read here: http://www.dreamincode.net/forums/topic/20020-using-udev-to-manage-hardware-in-linux/  

Notes:  
    /dev lists nodes representing attached hardware  
    /sys lists this same hardware, but contains extensive information about each unit  
    udev usually stores the default rules in /etc/udev/rules.d/50-udev.rules  
    rules are parsed in “lexical” order; good practice to create /etc/udev/rules.d/10-local.rules for your rules to allow parsing of   this file before the default one  
    run: 'find /sys -name usb' to find where usb devices are located  
    run: 'udevadm info -a -p ENTRY' for each entry in /sys/bus/usb/devices/; ENTRY == /sys/bus/usb/devices/FILENAME  
    #when the output contains the details of your scanner, note its key-value attributes  


#When running 'scanimage -L', each scanner that meets the condition will receive two names, one the name of the symlink defined in the rules and one name of the file in the operating system that represents the scanner.  
For example:  
device 'genesys:libusb:002:031' is a Canon LiDE 110 flatbed scanner  
device 'genesys:libusb:002:NQBSCANNER25' is a Canon LiDE 110 flatbed scanner  
If there was a problem with the laws we would only accept   
device 'genesys:libusb:002:031' is a Canon LiDE 110 flatbed scanner  

    #also, for this example, a symlink named NQBSCANNER25 should be found in /dev/bus/usb/002; check to confirm  

6) After any changes in the rules, run: 'sudo /etc/init.d/udev restart' and reconnect the scanner.  

key-values of interest: KERNEL and DEV#  

Scanner info is in /sys/bus/usb/devices/ folder  
run goal: 'udevadm info -a -p /sys/bus/usb/devices/num1-num2'  
#num1-num2 == (KERNAL_value)-(???)  
    #* ??? != (PORT + 1) != DEV#  

run: 'usb-devices' and find devices whose Product == 'EPSON Perfection V37/V370'  
output e.g.:  
T:  Bus=02 Lev=01 Prnt=01 Port=04 Cnt=01 Dev#= 16 Spd=480 MxCh= 0  
D:  Ver= 2.00 Cls=ff(vend.) Sub=ff Prot=ff MxPS=64 #Cfgs=  1  
P:  Vendor=04b8 ProdID=014a Rev=01.00  
S:  Manufacturer=EPSON  
S:  Product=EPSON Perfection V37/V370  
C:  #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr=2mA  
I:  If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)  

Thus, num1 == 2 & num2 == 4+1=5 *  

run: 'udevadm info -a -p /sys/bus/usb/devices/2-5  
output == properties of scanner; e.g.:  
  looking at device '/devices/pci0000:00/0000:00:1d.7/usb2/2-5':  
    KERNEL=="2-5"  
    SUBSYSTEM=="usb"  
    DRIVER=="usb"  
    ATTR{bDeviceSubClass}=="ff"  
    ATTR{bDeviceProtocol}=="ff"  
    ATTR{devpath}=="5"  
    ATTR{idVendor}=="04b8"  
    ATTR{speed}=="480"  
    ATTR{bNumInterfaces}==" 1"  
    ATTR{bConfigurationValue}=="1"  
    ATTR{bMaxPacketSize0}=="64"  
    ATTR{busnum}=="2"  
    ATTR{devnum}=="16"  
    ATTR{configuration}==""  
    ATTR{bMaxPower}=="2mA"  
    ATTR{authorized}=="1"  
    ATTR{bmAttributes}=="c0"  
    ATTR{bNumConfigurations}=="1"  
    ATTR{maxchild}=="0"  
    ATTR{bcdDevice}=="0100"  
    ATTR{avoid_reset_quirk}=="0"  
    ATTR{quirks}=="0x0"  
    ATTR{version}==" 2.00"  
    ATTR{urbnum}=="9"  
    ATTR{ltm_capable}=="no"  
    ATTR{manufacturer}=="EPSON"  
    ATTR{removable}=="unknown"  
    ATTR{idProduct}=="014a"  
    ATTR{bDeviceClass}=="ff"  
    ATTR{product}=="EPSON Perfection V37/V370"  

In the end we use rules:  
ATTR{product}=="CanoScan",SYMLINK+="bus/usb/00%s{busnum}/NQBSCANNER%k"  
ATTR{product}=="EPSON Perfection V37/V370", SYMLINK+="bus/usb/00%s{busnum}/NQBSCANNER%k"  
Where % k represents the kernel, the physical port and% s {busnum} represents the appropriate port on the main bus.  

7) 40-saned.rules allows scanners to only be used by the saned group  
run: 'usermod -aG saned username' to add your user to the saned group  
