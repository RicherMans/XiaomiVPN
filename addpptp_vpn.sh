#!/bin/sh

etc_network="/etc/config/network"
exits=$(grep -E "config interface 'vpn'" $etc_network | wc -l)

if [[ $exits -eq "1" ]]; then
  echo "Config exists, stopping!"
  exit
fi

alreadyinstalled=$(opkg list-installed | grep -E 'ppp-mod|kmod-ppp' | wc -l)
# If result are two lines, the packages for pptp are already installed

if [[ $alreadyinstalled -le "1" ]]; then
  opkg update
  opkg install ppp-mod-pptp kmod-nf-nathelper-extra
  if [[ $? -ne 0 ]]; then
    echo "Error occured during installation. Stopping"
  fi
fi



read -p "Please enter the VPN server: " server
read -p "Please enter the VPN username: " username
read -s -p "Please enter the VPN password: " pw

config="""
config interface 'vpn' 
        option 'ifname'    'pptp-vpn'  
        option 'proto'     'pptp'
        option 'username'  '$username'
        option 'password'  '$pw'
        option 'server'    '$server' 
        option 'buffering' '1' 
"""

echo "$config" >> $etc_network

if [[ $? -ne 0 ]]; then
    echo "Error occured during installation. Stopping"
else
    echo "Restarting network service ..." 
    /etc/init.d/network restart
    echo "Done"
fi


