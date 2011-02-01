#!/bin/sh

ipt="iptables"
ipta="$ipt -A INPUT"
ok="-j ACCEPT"

case "$IFACE" in
	eth0)	;;
	eth1)	;;
	*)	exit 0;;
esac

echo -n "Building IP firewall for $IFACE.."

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
$ipt -P FORWARD DROP
$ipt -P INPUT DROP
$ipt -P OUTPUT ACCEPT
$ipta -i lo $ok
$ipta -m state --state "ESTABLISHED,RELATED" $ok
for i in destination-unreachable time-exceeded echo-request echo-reply; do
$ipta -p icmp --icmp-type $i $ok
done

###### HOLES ######
for p in ssh 8000 38411 6891 2049 sunrpc 1022 rpc.statd; do
$ipta -p tcp --dport $p $ok
done
$ipta -p udp -i $IFACE --sport 53 --dport 1024:65535 $ok
$ipta -p udp -i $IFACE --sport 137 --dport 1024:65535 $ok

# UDP above 32767 is ok
#/sbin/iptables -A INPUT $IF -p udp --dport 0:32767 -j DROP
/sbin/iptables -A INPUT $IF -p udp -j ACCEPT

echo "Done."
