#!/bin/sh
#
# Restart VPNC if both of the specified hosts on the command line are unavailable

if ! [ $(ping -q -c 1 ${1} 2>&1 | grep "1 packets received" | sed "s/.*\(1\) packets received.*/\1/") ] ||
   ! [ $(ping -q -c 1 ${2} 2>&1 | grep "1 packets received" | sed "s/.*\(1\) packets received.*/\1/") ]; then
    echo Not alive $1 or $2, restarting VPNC
    /etc/init.d/add_vpn_rule restart
else
echo Alive $1 or $2
fi
