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
    sleep 5
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
	if [ $(sudo /usr/sbin/zerotier-cli listnetworks | grep -q "OK") ]; then
		echo
		echo '*** Node has joined the network!'
    	break
	fi
	echo '*** Waiting for join to complete...'
    sleep 5
	if [ $i -eq 4 ]; then
		echo
		echo '*** Giving up!'
		exit 1
	fi
done

ip a
ping -c 4 192.168.192.43

exit 0
