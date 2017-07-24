#!/bin/bash

output=./output
t1=/tmp/$$.1
t2=/tmp/$$.2

i=0
index=`cat $output |jq -r '.metadata.end_index'`
while [[ $i -lt $index ]]; do
    cat $output |jq -r '.entities['"$i"'] | [.context_types, .context_values] | transpose | map( {(.[0]): .[1]} ) | add' >$t1
    cat $output |jq -r '.entities['"$i"'] | {alert_type_uuid, created_time_stamp_in_usecs, severity, message}' >$t2
    strings=`cat $t2 |grep '"message":' |grep -oE '\{[^}]+\}' |xargs |tr -d '{}'`
    for str in $strings ; do
        result=`cat $t1 |awk -F'"' '/"'"$str"'":/ {print $4}'`
        echo $str $result
        sed -i '/"message":/s/{'"$str"'}/'"$result"'/' $t2
    done
    i=$((i+1))
    cat $t2
done

exit 0






#./$runfile 2>/dev/null |jq -r '.entities[] | select ( .alert_type_uuid == \"LoginInfoAudit\" ) | {alert_type_uuid, created_time_stamp_in_usecs, severity}'



#cmd="./$runfile 2>/dev/null |jq -r '.entities[] | {id, alert_type_uuid, message}' "$STR
#cmd="./$runfile 2>/dev/null |jq -r '.entities[] | {alert_type_uuid, created_time_stamp_in_usecs, severity}' "$STR
#cmd="./$runfile 2>/dev/null |jq -r '.entities[] | select ( .alert_type_uuid == \"LoginInfoAudit\" ) | {alert_type_uuid, created_time_stamp_in_usecs, severity}' "$STR
#eval $cmd
