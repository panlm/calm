#!/bin/bash

prismip=10.68.69.102

curl -kX GET -H "Authorization: Basic YWRtaW46bnV0YW5peC80dQ==" -H "Cache-Control: no-cache" -u admin:nutanix/4u "https://$prismip:9440/api/nutanix/v2.0/networks/" 2>/dev/null  |jq -r '.entities[] | {name, uuid, vlan_id}'

echo >> $0.log

