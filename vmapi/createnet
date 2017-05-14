#!/bin/bash

if [ $# -eq 0 ]; then
  echo "usage $0 net_name net_vlan"
  exit 999
fi

anno=$1
name=$1
vlan=$2

cat api-createnet |sed -e "s/annotationstring/$anno/" -e  "s/namestring/$name/" -e "s/vlanstring/$2/" > run-createnet
chmod a+x run-createnet

./run-createnet >/dev/null 2>&1

exit

curl -kX POST -H "Authorization: Basic YWRtaW46bnV0YW5peC80dQ==" -H "Content-Type: application/json" -H "Cache-Control: no-cache" -H "Postman-Token: 96cc3908-76f0-8041-d040-23ff37800423" -d '{
  "annotation": "annotationstring",
  "name": "namestring",
  "vlan_id": vlanstring,
  "vswitch_name": "br0"
}
' "https://10.68.69.102:9440/api/nutanix/v2.0/networks/"
