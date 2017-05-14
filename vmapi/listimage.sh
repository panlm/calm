#!/bin/bash

if [ $# -gt 1 ]; then
    echo "Usage: ./$0 [image_id]"
    exit
fi

if [ -x /usr/local/bin/in2csv ]; then
    STR=" |jq -s . |in2csv --format json - |csvlook"
else
    STR=""
fi

apifile=api-listimage
runfile=run-listimage

cat $apifile >$runfile
chmod a+x $runfile

case $# in
0)
    cmd="./$runfile 2>/dev/null |jq -r '.entities[] | {name, uuid, image_type, vm_disk_id}'"$STR
    eval $cmd
;;
1)
    cmd="./$runfile 2>/dev/null |jq -r '.entities[] | select (.uuid=="'"$1"'") | {name, uuid, image_type, vm_disk_id}'"$STR
    eval $cmd
;;
*)
    exit 9
;;
esac



