#!/bin/sh /etc/rc.common
START=100
STOP=40

VPN_ADDR=$VPN_ADDR
HOME_NET=$HOME_NET
VPN_DEV=$VPN_DEV

start(){
    echo "Enabling Routing for device "$VPN_DEV" to address "$VPN_ADDR" from and to Network "$HOME_NET
    ip route add default via $VPN_ADDR dev $VPN_DEV table vpn
    # Dunno why, but somehow lookup works, but table doesnt ... no idea why
    ip rule add to $HOME_NET=$HOME_NET lookup vpn
    ip rule add from $HOME_NET=$HOME_NET lookup vpn
}


stop(){
    ip route del default via $VPN_ADDR dev $VPN_DEV table vpn

    ip rule del to $HOME_NET
    ip rule del from $HOME_NET
}
