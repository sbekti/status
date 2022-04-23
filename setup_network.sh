#!/bin/bash

set -o pipefail

for i in 1 2 3 4; do
    status=$(sudo /usr/sbin/zerotier-cli info | cut -d' ' -f 5)
	if [ "$status" == "ONLINE" ]; then
		echo
		echo '*** Node is online!'
    	break
	fi
	echo '*** Waiting for node to become online...'
    sleep 15
	if [ $i -eq 4 ]; then
		echo
		echo '*** Giving up!'
		exit 1
	fi
done

echo
echo '*** Joining network...'
sudo zerotier-cli join $ZT_NETWORK_ID

for i in 1 2 3 4; do
	if $(sudo /usr/sbin/zerotier-cli listnetworks | grep -q "OK"); then
		echo
		echo '*** Node has joined the network!'
    	break
	fi
	echo '*** Waiting for join to complete...'
    sleep 15
	if [ $i -eq 4 ]; then
		echo
		echo '*** Giving up!'
		exit 1
	fi
done

echo
echo '*** Adding routes...'
sudo ip route add $INTERN_SUBNET via $INTERN_GATEWAY

echo
echo '*** Testing connectivity...'
ping -c 4 $INTERN_GATEWAY
ping -c 4 $PING_TEST_IP

exit 0
