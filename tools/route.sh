#!/bin/sh
# 作者：九千
# Run this script to share your Internet connection.
# Activate your gprs0 (phone data network) connection with the GUI

IP_ADDR="192.168.3.1"
NETMASK="255.255.255.0"
DHCP_RANGE="192.168.3.100,192.168.3.127"
RUNFILE="/var/run/wifi_tethering.pid"
DNSMASQ="/usr/sbin/dnsmasq"
ESSID="essid"
PASSWORD="essidpassword"
CHANNEL="10"
HOSTIDEV="eth0"

set -x

#start wlancond

# Load modules
modprobe crc7
modprobe mac80211
modprobe wl12xx
modprobe ipt_MASQUERADE

# flush old rules
iptables -F
iptables -t nat -F

iptables -t nat -A POSTROUTING -o $HOSTIDEV -j MASQUERADE

# forward IPs
echo 1 > /proc/sys/net/ipv4/ip_forward

ifconfig wlan0 down
iwconfig wlan0 mode ad-hoc
ifconfig wlan0 up
iwconfig wlan0 essid $ESSID
iwconfig wlan0 key s:$PASSWORD
iwconfig wlan0 channel $CHANNEL
ifconfig wlan0 $IP_ADDR netmask $NETMASK up

# Setup DNS and DHCP
#start-stop-daemon -S -p $RUNFILE -m -b -x $DNSMASQ -- -k -I lo -z -a $IP_ADDR -F $DHCP_RANGE -b

#run-standalone.sh dbus-send --type=method_call --dest=org.freedesktop.Notifications /org/freedesktop/Notifications org.freedesktop.Notifications.SystemNoteInfoprint string:'WiFi HotSpot Activated'
