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
    timefile=/var/tmp/$cluster-listevent.sh.timestamp
    outfile=/var/tmp/$cluster-listevent.sh.out.$timestamp
    apifile=$path/api-listevent
    runfile=$path/run-listevent-$cluster

    end_time=${timestamp}000000
    if [ -f $timefile ]; then
        start_time=`cat $timefile`
    else
        start_time=`echo $timestamp - 3600 |bc `000000
    fi
    
    #if [ -x /usr/bin/in2csv ]; then
    #    STR=" |jq -s . |in2csv --format json - |csvlook"
    #else
    #    STR=""
    #fi
    
    string1="start_time_in_usecs="$start_time
    string2="end_time_in_usecs="$end_time
    
    cat $apifile >$runfile
    sed -i "/https/s/events\/'/events\/?$string1\&$string2'/" $runfile
    sed -i "/https/s/10\.132\.68\.45/$cluster/" $runfile
    chmod a+x $runfile
    
    #save all alert to tmpfile
    ./$runfile 2>/dev/null |jq -r '.' >$outfile
    echo $end_time > $timefile
done

exit 0






#./$runfile 2>/dev/null |jq -r '.entities[] | select ( .alert_type_uuid == \"LoginInfoAudit\" ) | {alert_type_uuid, created_time_stamp_in_usecs, severity}'



#cmd="./$runfile 2>/dev/null |jq -r '.entities[] | {id, alert_type_uuid, message}' "$STR
#cmd="./$runfile 2>/dev/null |jq -r '.entities[] | {alert_type_uuid, created_time_stamp_in_usecs, severity}' "$STR
#cmd="./$runfile 2>/dev/null |jq -r '.entities[] | select ( .alert_type_uuid == \"LoginInfoAudit\" ) | {alert_type_uuid, created_time_stamp_in_usecs, severity}' "$STR
#eval $cmd
