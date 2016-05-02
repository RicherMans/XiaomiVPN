#!/bin/sh


# Define variables
ADDRULE_SCRIPT="add_vpn_tables.sh"
RECONNECT_SCRIPT="vpn-keepalive.sh"
VPN_ADDR="192.168.2.1"
HOME_NET="192.168.72.3"
VPN_DEV="192.255.1.1"
TMP_SCRIPT_FILE=$(mktemp /tmp/tmpinstaller.XXXXXX)

addVPNTable () {
    # Add the VPN rule into IpTables
    rttables="/etc/iproute2/rt_tables"
    if ! grep -q 'vpn' $rttables ; then
      echo "10    vpn" >> $rttables
    fi 
}

replaceAddScript () {

    local scriptfile=$1
    local tmpfile=$2

    touch $tmpfile

    sed "s/VPN_ADDR=\$VPN_ADDR/VPN_ADDR=$VPN_ADDR/g" $ADDRULE_SCRIPT >> $tmpfile
    sed -i "s/HOME_NET=\$HOME_NET/HOME_NET=$HOME_NET/g" $tmpfile
    sed -i "s/VPN_DEV=\$VPN_DEV/VPN_DEV=$VPN_DEV/g" $tmpfile

}

# replaceRestart () {

# }


# Prompts to obtain the VPN_ADDR variable
# while true; do
#         echo -n "Please input the remote VPN address of the VPN!"
#         read answer
#         if echo "$answer" | grep -qE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" ;then
#             VPN_ADDR=$answer
#             break;
#         else
#             echo "Given argument is not a ip adress, retry!"
#         fi
# done

# # Prompts to obtain the HOME_NET Variable
# while true; do
#         echo -n "Please input the current networks specified ip address, which the VPN is connected to!"
#         read answer
#         if echo "$answer" | grep -qE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" ;then
#             HOME_NET=$answer
#             break;
#         else
#             echo "Given argument is not a ip adress, retry!"
#         fi
#     done
# # Prompts to obtain the VPN_DEV Variable
# while true; do
#         echo -n "Please input the local VPN device's name!"
#         read answer
#         if echo "$answer" | grep -qE "^[a-zA-Z]" ;then
#             VPN_DEV=$answer
#             break;
#         else
#             echo "Given argument is not a device name, retry!"
#         fi
# done

echo "Checking for the VPN-Device to exist"

isup=$(ip a | grep -Eq ': $VPN_DEV:.*state UP')

replaceAddScript $ADDRULE_SCRIPT $TMP_SCRIPT_FILE


# Copying scripts
cp $ADDRULE_SCRIPT /etc/init.d/$ADDRULE_SCRIPT
chmod a+x /etc/init.d/$ADDRULE_SCRIPT

cp $RECONNECT_SCRIPT /etc/init.d/$RECONNECT_SCRIPT
chmod a+x /etc/init.d/$RECONNECT_SCRIPT

# Adds to the vpn table configure
addVPNTable

if [ -e "/etc/init.d/$RECONNECT_SCRIPT" ]; then
  if ! fgrep -q "vpn" '/etc/crontab' ; then
    echo "Adding reconnect script to crontab"
    echo "*/5 * * * * /etc/init.d/vpn_keepalive.sh > /dev/null" >> /etc/crontab
  fi
fi

/etc/init.d/cron start && /etc/init.d/cron enable && echo "Starting Crobjob to reconnect VPN"

