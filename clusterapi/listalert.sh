#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 cluster1_ip cluster2_ip ... "
    exit 9
fi

export PATH=$PATH:/usr/local/bin
umask 0000
timestamp=`date +%s`

for i in $* ; do
    cluster=$i
    path=`dirname $0`
    timefile=/var/tmp/$cluster-listalert.sh.timestamp
    outfile=/var/tmp/$cluster-listalert.sh.out.$timestamp
    alertfile=/var/tmp/$cluster-listalert.sh.alert.$timestamp
    apifile=$path/api-listalert
    runfile=$path/run-listalert-$cluster

    #get start_time and end_time
    #if no timefile then period is the last hour
    end_time=${timestamp}000000
    if [ -f $timefile ]; then
        start_time=`cat $timefile`
    else
        start_time=`echo $timestamp - 3600 |bc `000000
    fi
    
    #Optional Format with csvlook
    #if [ -x /usr/bin/in2csv ]; then
    #    STR=" |jq -s . |in2csv --format json - |csvlook"
    #else
    #    STR=""
    #fi
    
    string1="start_time_in_usecs="$start_time
    string2="end_time_in_usecs="$end_time
    
    cat $apifile >$runfile
    sed -i "/https/s/alerts\/'/alerts\/?$string1\&$string2'/" $runfile
    sed -i "/https/s/10\.132\.68\.45/$cluster/" $runfile
    chmod a+x $runfile
    
    #save all alert to tmpfile
    $runfile 2>/dev/null |/usr/local/bin/jq -r '.' >$outfile

    #start prase tmpfile and write to alertfile
    t1=/var/tmp/$$.1
    t2=/var/tmp/$$.2
    i=0
    index=`cat $outfile |jq -r '.metadata.end_index'`
    while [[ $i -lt $index ]]; do
        cat $outfile |jq -r '.entities['"$i"'] | [.context_types, .context_values] | transpose | map( {(.[0]): .[1]} ) | add' >$t1
        cat $outfile |jq -r '.entities['"$i"'] | {alert_type_uuid, created_time_stamp_in_usecs, severity, message}' >$t2
        #get all replacement string, like {container_name} or {remote_site}
        strings=`cat $t2 |grep '"message":' |grep -oE '\{[^}]+\}' |xargs |tr -d '{}'`
        for str in $strings ; do
            result=`cat $t1 |awk -F'"' '/"'"$str"'":/ {print $4}'`
            sed -i '/"message":/s/{'"$str"'}/'"$result"'/' $t2
        done
        i=$((i+1))
        cat $t2 >> $alertfile
    done
    rm -f $t1 $t2
    echo $end_time > $timefile
done
    
exit 0






#./$runfile 2>/dev/null |jq -r '.entities[] | select ( .alert_type_uuid == \"LoginInfoAudit\" ) | {alert_type_uuid, created_time_stamp_in_usecs, severity}'



#cmd="./$runfile 2>/dev/null |jq -r '.entities[] | {id, alert_type_uuid, message}' "$STR
#cmd="./$runfile 2>/dev/null |jq -r '.entities[] | {alert_type_uuid, created_time_stamp_in_usecs, severity}' "$STR
#cmd="./$runfile 2>/dev/null |jq -r '.entities[] | select ( .alert_type_uuid == \"LoginInfoAudit\" ) | {alert_type_uuid, created_time_stamp_in_usecs, severity}' "$STR
#eval $cmd