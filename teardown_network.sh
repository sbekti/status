#!/bin/bash

echo
echo '*** Leaving network...'
sudo zerotier-cli leave $ZT_NETWORK_ID

exit 0
