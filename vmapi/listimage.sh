#!/bin/bash

if [ $# -gt 1 ]; then
  echo "Usage: ./$0 [image_id]"
  exit
fi

apifile=api-listimage
runfile=run-listimage

cat $apifile >$runfile
chmod a+x $runfile

case $# in
0) ./$runfile 2>/dev/null |jq -r '.entities[] | {name, uuid, image_type, vm_disk_id}'
;;
1) ./$runfile 2>/dev/null |jq -r '.entities[] | select (.uuid=="'"$1"'") | {name, uuid, image_type, vm_disk_id}'
;;
*) exit 9
;;
esac

exit



