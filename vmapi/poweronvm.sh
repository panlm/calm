#!/bin/bash

if [ $# -gt 2 ]; then
  echo "Usage: ./$0 [vmuuid]"
  exit 9
fi

case $# in
0)
  ./listvm.sh
;;
1)
    uuid=$1
    apifile=api-poweronvm
    runfile=run-poweronvm
    cat $apifile |sed -e 's/uuidstring/'"$uuid"'/' >$runfile 2>&1
    chmod a+x $runfile
    ./$runfile >$0.log 2>&1
;;
*)
    exit
;;
esac

curl -kX POST -H "Authorization: Basic YWRtaW46bnV0YW5peC80dQ==" -H "Content-Type: application/json" -H "Cache-Control: no-cache" -H "Postman-Token: 794e73ee-3d32-eb06-4c4a-3ecd90349326" -d '{ "transition": "ON" }' "https://10.68.69.102:9440/api/nutanix/v2.0/vms/1a78a575-be12-4a49-8802-0128b63c9fee/set_power_state/" >> $0.log 2>/dev/null 

echo >> $0.log
