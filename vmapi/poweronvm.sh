#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 [vmuuid] [on|off|reset]"
    exit 9
fi

operationstring=`echo $2 |tr [a-z] [A-Z]`

if [ ! $operationstring == 'ON' ]; then
    if [ ! $operationstring == 'OFF' ]; then
        if [ ! $operationstring == 'RESET' ]; then
            echo "Usage: $0 [vmuuid] [on|off|reset]"
            exit 9
        fi
    fi
fi

uuid=$1
apifile=api-poweronvm
runfile=run-poweronvm
cat $apifile |sed -e 's/uuidstring/'"$uuid"'/' \
    -e '/transition/s/ON/'"$operationstring"'/' >$runfile 2>&1
chmod a+x $runfile

./$runfile >${0%.*}.log 2>&1

