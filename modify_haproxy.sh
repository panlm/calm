#!/bin/bash

cd /etc/haproxy
cp haproxy.cfg haproxy.cfg.`date +%Y%m%d%H%M%S`
sed -i '/^listen wordpress 0.0.0.0:80$/,/^$/d' haproxy.cfg
cat ~/git/haproxy_wordpress.cfg >>haproxy.cfg

cat /etc/hosts |grep -E 'wordpress[0-9]\+' |awk '{print $2,$1}' |sed -e 's/^/    server /' -e 's/$/:80 check/' >>haproxy.cfg

systemctl restart haproxy

#    server wordpress0 10.68.69.45:80 check
