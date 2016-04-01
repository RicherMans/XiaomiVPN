#!/bin/sh






SCRIPTNAME="add_vpn_tables.sh"
# Add the VPN rule into IpTables


addVPNTable(){
    echo "10    vpn" >> /etc/iproute2/rt_tables
}

replaceAddScript () {

    tmpfile="tmpscriptfile"

    touch $tmpfile

    sed "s/VPN_ADDR=\$VPN_ADDR/VPN_ADDR=$VPN_ADDR/g" $SCRIPTNAME >> $tmpfile
    sed -i "s/HOME_NET=\$HOME_NET/HOME_NET=$HOME_NET/g" $tmpfile
    sed -i "s/VPN_DEV=\$VPN_DEV/VPN_DEV=$VPN_DEV/g" $tmpfile

}

VPN_ADDR="awd"
HOME_NET=""
VPN_DEV=""

# Prompts to obtain the VPN_ADDR variable
while true; do
        echo -n "Please input the remote VPN address of the VPN!\t"
        read answer
        if echo "$answer" | grep -qE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" ;then
            VPN_ADDR=$answer
            break;
        else
            echo "Given argument is not a ip adress, retry!"
        fi
done

# Prompts to obtain the HOME_NET Variable
while true; do
        echo -n "Please input the current networks specified ip address, which the VPN is connected to!\t"
        read answer
        if echo "$answer" | grep -qE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" ;then
            HOME_NET=$answer
            break;
        else
            echo "Given argument is not a ip adress, retry!"
        fi
    done
# Prompts to obtain the VPN_DEV Variable
while true; do
        echo -n "Please input the local VPN device's name!\t"
        read answer
        if echo "$answer" | grep -qE "^[a-zA-Z]" ;then
            VPN_DEV=$answer
            break;
        else
            echo "Given argument is not a device name, retry!"
        fi
done

echo "Checking for the VPN-Device to exist"

ip a | grep -Eq ': $VPN_DEV:.*state UP'

replaceAddScript


# cp $SCRIPTNAME /etc/init.d/
# chmod a+x /etc/init.d/$SCRIPTNAME




