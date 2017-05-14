#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Usage: ./$0 vm_name [large|small] image_disk_id"
    exit 9
fi

namestring=$1
imagestring=$3

case $2 in
large)
    memorystring=2048
    corestring=2
    vcpustring=1
;;
small)
    memorystring=1024
    corestring=1
    vcpustring=1
;;
*)
    echo "error vm size type, only \"large\" or \"small\" allowed"
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

./$runfile >>${0%.*}.log 2>/dev/null

