#!/bin/bash

prismip=10.68.69.102

string=`curl -kX GET -H "Authorization: Basic YWRtaW46bnV0YW5peC80dQ==" -H "Cache-Control: no-cache" -H "Postman-Token: 9473a44b-bf89-5c2b-6536-7f4512252a38" "https://10.68.69.102:9440/api/nutanix/v2.0/cluster/" 2>/dev/null  |jq -r '.name,.cluster_external_ipaddress,.cluster_external_data_services_ipaddress,.cluster_uuid,.id' |xargs `

name=`echo $string |awk '{print $1}'`
clusterip=`echo $string |awk '{print $2}'`
dataserviceip=`echo $string |awk '{print $3}'`
uuid=`echo $string |awk '{print $4}'`
id=`echo $string |awk '{print $5}'`


echo "name: $name"
echo "clusterip: $clusterip"
echo "dataserviceip: $dataserviceip"
echo "uuid: $uuid"
echo "id: $id"


