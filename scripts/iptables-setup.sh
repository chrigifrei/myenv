#!/bin/bash
IPT="/sbin/iptables"
LOG_FILE="/var/log/iptables.log"

# Server IP
SERVER_IP="$(ip addr show eth0 | grep 'inet ' | cut -f2 | awk '{ print $2}')"

# Your DNS servers you use: cat /etc/resolv.conf
DNS_SERVER=$(grep nameserver /etc/resolv.conf | awk '{printf "%s ",$2} END {print ""}')

# Allow connections to this package servers
ALLOW_PKG_SRV=false
PACKAGE_SERVER="192.168.1.1 192.168.1.100"

echo "flush iptable rules"
$IPT -F
$IPT -X
$IPT -t nat -F
$IPT -t nat -X
$IPT -t mangle -F
$IPT -t mangle -X


## This should be one of the first rules.
## so dns lookups are already allowed for your other rules
for ip in $DNS_SERVER
do
	echo "Allowing DNS lookups (tcp, udp port 53) to server '$ip'"
	$IPT -A OUTPUT -p udp -d $ip --dport 53 -j ACCEPT
	$IPT -A INPUT  -p udp -s $ip --sport 53 -j ACCEPT
	$IPT -A OUTPUT -p tcp -d $ip --dport 53 -j ACCEPT
	$IPT -A INPUT  -p tcp -s $ip --sport 53 -j ACCEPT
done

echo "allow all and everything on localhost"
$IPT -A INPUT -i lo -j ACCEPT
$IPT -A OUTPUT -o lo -j ACCEPT

if [ "$ALLOW_PKG_SRV" == "true" ]; then
	for ip in $PACKAGE_SERVER
	do
		echo "Allow connection to '$ip' on port 80"
		$IPT -A OUTPUT -p tcp -d "$ip" --dport 80 -j ACCEPT
		$IPT -A INPUT  -p tcp -s "$ip" --sport 80 -j ACCEPT

		echo "Allow connection to '$ip' on port 443"
		$IPT -A OUTPUT -p tcp -d "$ip" --dport 443 -j ACCEPT
		$IPT -A INPUT  -p tcp -s "$ip" --sport 443 -j ACCEPT
	done
fi


#######################################################################################################
## Global iptable rules. Not IP specific

echo "Allowing new and established incoming connections to SKLM ports"
#$IPT -A INPUT  -p tcp -m multiport --dports 9080:9099 -m state --state NEW,ESTABLISHED -j ACCEPT
#$IPT -A OUTPUT -p tcp -m multiport --sports 9080:9099 -m state --state ESTABLISHED     -j ACCEPT
#$IPT -A INPUT  -p tcp -m multiport --dports 5696,441,3801,50020 -m state --state NEW,ESTABLISHED -j ACCEPT
#$IPT -A OUTPUT -p tcp -m multiport --sports 5696,441,3801,50020 -m state --state ESTABLISHED     -j ACCEPT
$IPT -A INPUT  -p tcp --dport 9080:9099 -j ACCEPT
$IPT -A OUTPUT -p tcp --sport 9080:9099 -j ACCEPT
$IPT -A INPUT  -p tcp -m multiport --dports 5696,441,3801,50020 -j ACCEPT
$IPT -A OUTPUT -p tcp -m multiport --sports 5696,441,3801,50020 -j ACCEPT

echo "Allow all outgoing connections to port 22"
#$IPT -A INPUT -p tcp -s 0/0 -d $SERVER_IP --sport 513:65535 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
#$IPT -A OUTPUT -p tcp -s $SERVER_IP -d 0/0 --sport 22 --dport 513:65535 -m state --state ESTABLISHED -j ACCEPT
$IPT -A INPUT -p tcp --dport 22 -j ACCEPT
$IPT -A OUTPUT -p tcp --sport 22 -j ACCEPT

echo "Allow outgoing icmp connections (pings,...)"
$IPT -A OUTPUT -p icmp -j ACCEPT
$IPT -A INPUT  -p icmp -j ACCEPT

echo "Allow outgoing connections to port 123 (ntp syncs)"
$IPT -A OUTPUT -p udp --dport 123 -j ACCEPT
$IPT -A INPUT  -p udp --sport 123 -j ACCEPT

# Log before dropping
echo "enable logging"
$IPT -A INPUT  -j LOG  -m limit --limit 12/min --log-level 4 --log-prefix 'iptables INPUT drop: '
$IPT -A INPUT  -j DROP

$IPT -A OUTPUT -j LOG  -m limit --limit 12/min --log-level 4 --log-prefix 'iptables OUTPUT drop: '
$IPT -A OUTPUT -j DROP

if ! grep iptables /etc/rsyslog.conf 1> /dev/null; then 
	entry="# iptables.log\n \
:msg, contains, \"iptables\"                              $LOG_FILE\n \
:msg, contains, \"iptables\"                              ~\n"
	sed -i "/RULES/a $entry" /etc/rsyslog.conf
	service rsyslog restart
fi

if ! grep iptables /etc/logrotate.d/syslog 1> /dev/null; then 
	sed -i '/\/var\/log\/messages/a /var/log/iptables.log' /etc/logrotate.d/syslog
fi

echo "Set default policy to 'DROP'"
$IPT -P INPUT   DROP
$IPT -P FORWARD DROP
$IPT -P OUTPUT  DROP

service iptables save
service iptables restart

exit 0
