#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: ./$0 start_time end_time"
    exit 9
fi

if [ -x /usr/bin/in2csv ]; then
    STR=" |jq -s . |in2csv --format json - |csvlook"
else
    STR=""
fi

string1="start_time_in_usecs="$1
string2="end_time_in_usecs="$2

apifile=api-listevent
runfile=run-listevent

cat $apifile >$runfile
sed -i "s/events\/'/events\/?$string1\&$string2'/" $runfile
chmod a+x $runfile

#cmd="./$runfile 2>/dev/null |jq -r '.entities[] | {id, alert_type_uuid, message}' "$STR
#cmd="./$runfile 2>/dev/null |jq -r '.entities[] | {alert_type_uuid, created_time_stamp_in_usecs, severity}' "$STR
cmd="./$runfile 2>/dev/null |jq -r '.entities[] | select ( .alert_type_uuid == \"LoginInfoAudit\" ) | {alert_type_uuid, created_time_stamp_in_usecs, severity}' "$STR
eval $cmd
