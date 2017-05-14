#!/bin/bash

if [ $# -eq 0 ]; then
    echo "usage $0 net_uuid"
    exit 999
fi

networkuuid=$1

cat api-deletenet |sed -e "s/networkuuid/$networkuuid/" > run-deletenet
chmod a+x run-deletenet

./run-deletenet

