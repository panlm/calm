#!/bin/bash

if [ $# -ne 0 ]; then
    echo "Usage: ./$0 "
    exit
fi

if [ -x /usr/local/bin/in2csv ]; then
    STR=" |jq -s . |in2csv --format json - |csvlook"
else
    STR=""
fi

apifile=api-listvm
runfile=run-listvm

cat $apifile >$runfile
chmod a+x $runfile

cmd="./$runfile 2>/dev/null |jq -r '.entities[] | {name, uuid, power_state}'"$STR
eval $cmd

exit



