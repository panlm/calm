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

