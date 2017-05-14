#!/bin/bash

if [ $# -ne 3 ]; then
  echo "Usage: ./$0 vm_name [large|small] image_disk_id"
  exit 9
fi

namestring=$1
imagestring=$3

case $2 in
large) memorystring=2048
       corestring=2
       vcpustring=1
;;
small) memorystring=1024
       corestring=1
       vcpustring=1
;;
*)     echo "error vm size type, only \"large\" or \"small\" allowed"
       exit 9
;;
esac

apifile=api-clonevm
runfile=run-clonevm

cat $apifile |sed -e 's/namestring/'"$namestring"'/' \
  -e 's/memorystring/'"$memorystring"'/' \
  -e 's/corestring/'"$corestring"'/' \
  -e 's/vcpustring/'"$vcpustring"'/' \
  -e 's/imagestring/'"$imagestring"'/' >$runfile

chmod a+x $runfile

./$runfile >>$0.log 2>/dev/null



exit

curl -kX POST -H "Content-Type: application/json" -H "Authorization: Basic YWRtaW46bnV0YW5peC80dQ==" -H "Cache-Control: no-cache" -H "Postman-Token: b86658b7-5d86-1179-7daa-78b4bb6d2a39" -d '{ "name": "win-2", "description": "win-2", "memory_mb": 4096, "num_cores_per_vcpu": 2, "num_vcpus": 1, "timezone": "Asia/Shanghai", "vm_disks": [ { "disk_address": { "device_bus": "IDE", "device_index": 0 }, "is_cdrom": true, "is_empty": false, "vm_disk_clone": { "disk_address": { "vmdisk_uuid": "3a90058c-b9bc-4a32-833b-4d5bf789e86d" }} }, { "disk_address": { "device_bus": "IDE", "device_index": 1 }, "is_cdrom": true, "is_empty": false, "vm_disk_clone": { "disk_address": { "vmdisk_uuid": "05c70673-f0e1-4fc7-a37a-c45b03d7c90d" }} }, { "disk_address": { "device_bus": "SCSI", "device_index": 0 }, "is_cdrom": false, "is_empty": true, "vm_disk_create": { "size": 42949672960, "storage_container_uuid": "a6ff0a1b-ffc1-4d4c-b71a-e6a0e67e008d" } } ], "vm_nics": [ { "adapter_type": "E1000", "network_uuid": "de142a1a-26c7-44d8-8541-e7309ee200cd", "request_ip": false } ] }' "https://10.68.69.102:9440/PrismGateway/services/rest/v2.0/vms/" >> $0.log 2>/dev/null

echo >> $0.log

