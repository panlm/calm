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
    apifile=api-deletevm
    runfile=run-deletevm
    cat $apifile |sed -e 's/uuidstring/'"$uuid"'/' >$runfile 2>&1
    chmod a+x $runfile
    ./$runfile >${0%.*}.log 2>&1
;;
*)
    exit
;;
esac

exit

