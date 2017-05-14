#!/bin/bash

if [ $# -ne 0 ]; then
  echo "Usage: ./$0 "
  exit
fi

apifile=api-listvm
runfile=run-listvm

cat $apifile >$runfile
chmod a+x $runfile

./$runfile 2>/dev/null |jq -r '.entities[] | {name, uuid, power_state}'

exit



