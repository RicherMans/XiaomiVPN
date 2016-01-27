# XiaomiVPN
A short introduction how to successfully install a VPN client on a Xiaomi router (MiWifi Mini).

When this router was setup, I faced many problems. I'd like to clarify them here and offer solutions to the most common hinderances.

The setup is as follows:

The router will have a usual connection which goes out with WAN. 
Additionally this connection is spread over WiFi into a certain SSID.
On top of that another SSID is established which operates exclusively over the VPN.

## Installation of OpenWrt

To install Openwrt on the MiWifi Router, manifold tutorials exists. [This](https://wiki.openwrt.org/toh/xiaomi/mini) tutorial is the official OpenWrt tutorial. 
In short you need to:
1. Register at the Mi Website your device
2. [Download](http://www1.miwifi.com/miwifi_download.html) the development firmware and the [SSH](http://d.miwifi.com/rom/ssh) Flash.
3. Flashing first the device using the development firmware, using a pendrive/usb. After development firmware is installed the same procedure needs to be done with the SSH patch.
4. Connect to the device using SSH. The password is obtained on the SSH website, if registration has already succeeded. 
    ```bash
    root@192.168.31.1
    ```
5. Flash with your preferred firmware the device. E.g. 
    ```bash 
    cd /tmp; wget http://downloads.openwrt.org/chaos_calmer/15.05/ramips/mt7620/openwrt-15.05-ramips-mt7620-xiaomi-miwifi-mini-squashfs-sysupgrade.bin
    cat /proc/mtd
    ```

One other option is directly getting PandoraBox, which comes with some preinstalled packages, from [here](http://downloads.openwrt.org.cn/PandoraBox/Xiaomi-Mini-R1CM/stable/)
If there is a line "OS1", use OS1 in the following command as parameter, otherwise "firmware".

```bash
mtd -r write openwrt-15.05-ramips-mt7620-xiaomi-miwifi-mini-squashfs-sysupgrade.bin OS1
```

6. After flashing is done, connect via LAN to the device on host 
```bash 
ssh root@192.168.1.1
``` 
with User: root, no password.

Youre done and can begin working on the newly installed OpenWRT router.


## Necessary Packages

Multiple Packages are required to get a VPN and ChinaDNS running.

### PPTP

When using PPTP as a VPN client, the following packages need to be installed.
The package ```kmod-nf-nathelper-extra``` removes the default block of the PPTP client (since Chaos Chalmer).

```bash
opkg update
opkg install ppp-mod-pptp kmod-nf-nathelper-extra
opkg install luci-proto-ppp
```

### ChinaDNS
ChinaDNS, and ChinaDns-Luci ( if GUI is requested )

Take one of [these](http://sourceforge.net/projects/openwrt-dist/files/luci-app/chinadns/) luci-apps and accoringly one ChinaDNS [package](http://sourceforge.net/projects/openwrt-dist/files/chinadns/1.3.2-d3e75dd/ChinaDNS_1.3.2-3_ramips_24kec.ipk/download).

After the installation of the Luci package, a new category under the "Services" will appear. Click on Services --> ChinaDNS. 

Now configure the following:

- [x] Enable
- [x] Enable Bidirectional Filter
- Local Port: 5353
- CHNRoute File: /etc/chinadns_chnroute.txt
- Upstream Servers: 114.114.114.114,8.8.8.8



### Why do we need ChinaDNS?
It appreads that in some cases, even if your VPN is running, Chinas GFW will still block content from youtube and facebook ( maybe also others, but these were the most prominent). This is due to DNS poisoning from their side which somehow is not circumvented in the router ( Using the VPN on any usual device somehow leads to a proper result).



