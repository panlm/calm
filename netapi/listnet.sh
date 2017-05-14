#!/bin/bash

if [ $# -ne 0 ]; then
    echo "Usage: ./$0 "
    exit 9
fi

if [ -x /usr/local/bin/in2csv ]; then
    STR=" |jq -s . |in2csv --format json - |csvlook"
else
    STR=""
fi

apifile=api-listnet
runfile=run-listnet

cat $apifile >$runfile
chmod a+x $runfile

cmd="./$runfile 2>/dev/null |jq -r '.entities[] | {name, uuid, vlan_id}' "$STR
eval $cmd

