#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: ./$0 vm_name [large|small] "
  exit 9
fi

namestring=$1

case $2 in
large)
    memorystring=4096
    corestring=2
    vcpustring=2
    #diskstring=100G
    diskstring=107374182400
;;
small)
    memorystring=2048
    corestring=2
    vcpustring=1
    #diskstring=40G
    diskstring=42949672960
;;
*)
    echo "error vm size type, only \"large\" or \"small\" allowed"
    exit 9
;;
esac

apifile=api-createvm
runfile=run-createvm

cat $apifile |sed -e 's/namestring/'"$namestring"'/' \
  -e 's/memorystring/'"$memorystring"'/' \
  -e 's/corestring/'"$corestring"'/' \
  -e 's/vcpustring/'"$vcpustring"'/' \
  -e 's/diskstring/'"$diskstring"'/' >$runfile

chmod a+x $runfile

./$runfile >>${0%.*}.log 2>/dev/null

