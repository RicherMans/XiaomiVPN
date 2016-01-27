#!/bin/sh

SCRIPTNAME="add_vpn_tables.sh"
# Add the VPN rule into IpTables
echo "10    vpn" >> /etc/iproute2/rt_tables


sed -i 's/VPN_ADDR/VPN_ADDR=$VPN_ADDR/g' $SCRIPTNAME
sed -i 's/HOME_NET/HOME_NET=$HOME_NET/g' $SCRIPTNAME
sed -i 's/VPN_DEV/VPN_DEV=$VPN_DEV/g' $SCRIPTNAME

cp $SCRIPTNAME /etc/init.d/
chmod a+x /etc/init.d/$SCRIPTNAME




