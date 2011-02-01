#!/bin/sh

[ "$IFACE" == "eth0" ] || [ "$IFACE" == "eth1" ] || exit 1

# Firewall
ipt="iptables"
ipta="$ipt -A INPUT"
ok="-j ACCEPT"

echo -n "Clearing IP Firewalling on $IFACE..."

# Allow "most" outgoing packets. Exceptions:
#  - Block ports that run services which might, if enabled by
#    accident, harm the network and piss off the admins.
#    - DHCPD
# Deny "most" incoming packets. Exceptions:
#    - sshd
#    - 

$ipt -P INPUT DROP
$ipt -P FORWARD DROP
$ipt -F # delete all rules in normal chains
$ipt -t nat -F
$ipt -t mangle -F
$ipt -X # delete all user-defined rules
$ipt -t nat -X
$ipt -t mangle -X

## Workstation minimal firewall ##
$ipt -P FORWARD ACCEPT
$ipt -P INPUT ACCEPT
$ipt -P OUTPUT ACCEPT
echo "Done."
