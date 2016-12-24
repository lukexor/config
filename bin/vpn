#!/usr/bin/env bash

if (( EUID != 0 )); then
  echo "Please, run this command with sudo" 1>&2
  exit 1
fi

openvpn ~/.dotfiles/openvpn.vpn > /dev/null 2&>1 &

WIRELESS_INTERFACE=en0
TUNNEL_INTERFACE=utun1
GATEWAY=$(netstat -nrf inet | grep default | grep $WIRELESS_INTERFACE | awk '{print $2}')

echo "Resetting routes with gateway => $GATEWAY"
echo
route -n delete default -ifscope $WIRELESS_INTERFACE
route -n delete -net default -interface $TUNNEL_INTERFACE
route -n add -net default $GATEWAY
for subnet in  10.109 10.110
do
  route -n add -net $subnet -interface $TUNNEL_INTERFACE
done
