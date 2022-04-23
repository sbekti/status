#!/bin/bash

set -o pipefail

echo
echo '*** Tearing down network...'
sudo zerotier-cli leave $ZT_NETWORK_ID || true

exit 0
