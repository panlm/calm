#!/bin/bash

if [ $# -eq 0 ]; then
  echo "usage $0 net_uuid"
  exit 999
fi

networkuuid=$1

cat api-deletenet |sed -e "s/networkuuid/$networkuuid/" > run-deletenet
chmod a+x run-deletenet

./run-deletenet

exit

curl -kX POST -H "Authorization: Basic YWRtaW46bnV0YW5peC80dQ==" -H "Content-Type: application/json" -H "Cache-Control: no-cache" -H "Postman-Token: 96cc3908-76f0-8041-d040-23ff37800423" -d '{
  "annotation": "annotationstring",
  "name": "namestring",
  "vlan_id": vlanstring,
  "vswitch_name": "br0"
}
' "https://10.68.69.102:9440/api/nutanix/v2.0/networks/"
