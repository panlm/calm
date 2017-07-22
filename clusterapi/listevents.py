#!/usr/bin/env python
# depends py-zabbix, using 'pip install py-zabbix' to install it.

import argparse
import re
import sys
import os
import time
import netsnmp
from os import stat
from pyzabbix import ZabbixAPI, ZabbixMetric, ZabbixSender

parser = argparse.ArgumentParser()
parser.add_argument('-f', '--format', action="store", dest='format', default='json')
parser.add_argument('-D', '--debug', action="store_true", dest='isdebug', default=False)
# for Prism REST API
parser.add_argument('--prism_server', action="store", dest='prism_server', default='10.132.68.45')
parser.add_argument('--prism_user', action="store", dest='prism_user', default='leiming.pan@nutanix.sh')
parser.add_argument('--prism_pass', action="store", dest='prism_pass', default='nutanix/4u')

param = parser.parse_args()
if param.isdebug:
    print param.prism_server,param.prism_user,param.prism_pass


session = netsnmp.Session(DestHost=param.hostname, Version=param.snmpversion, SecLevel=param.seclevel, AuthProto=param.authproto, AuthPass=param.authpass, PrivProto=param.privproto, PrivPass=param.privpass, SecName=param.username)
#vars = netsnmp.VarList(netsnmp.Varbind('sysDescr', '0'))
string = netsnmp.VarList(netsnmp.Varbind(uptimeoid),
                         netsnmp.Varbind('ssCpuRawUser', '0'),
                         netsnmp.Varbind('ssCpuRawSystem', '0'),
                         netsnmp.Varbind('ssCpuRawNice', '0'),
                         netsnmp.Varbind('ssCpuRawIdle', '0'),
                         netsnmp.Varbind('ssCpuRawWait', '0'))

# get current values
vars = session.get(string)
if param.isdebug:
    print vars

# if tmpfile existed, read it as last value. 
# if tmpfile does not existed, save current values as last value, and sleep 10 sec
tmpfile = '/var/tmp/' + re.sub('\..*$', '', re.sub('^.*/', r'', sys.argv[0])) + '-' + param.hostname
if not os.path.exists(tmpfile):
    last_vars = vars
    if param.isdebug:
        print last_vars
    time.sleep(10)
else:
    f = open(tmpfile,'r')
    last_vars = []
    for line in f:
        last_vars.append(line.strip('\n'))
    if param.isdebug:
        print last_vars
    f.close()

# get newest value (get again)
vars = session.get(string)
if param.isdebug:
    print "get again"
    print vars

# get diff from newest and last
i=1
diff_vars = []
while i < len(vars):
    a=int(last_vars[i])
    b=int(vars[i])
    # wrap
    if b < a:
        b = b + 4294967295 + 1
    diff_vars.append(b - a)
    i = i + 1
if param.isdebug:
    print diff_vars

f = open(tmpfile,'w')
for i in vars:
    f.write(i)
    f.write('\n')
f.close()
if os.geteuid() == stat(tmpfile).st_uid:
    os.chmod(tmpfile,0o0666)

total = 0
for i in diff_vars:
    total = total + i
if param.isdebug:
    print "total:%s\n" % (total)

# prevent you run this script too fast.
if total != 0:
    cpu_user = float(diff_vars[0]) / total * 100
    cpu_sys  = float(diff_vars[1]) / total * 100
    cpu_nice = float(diff_vars[2]) / total * 100
    cpu_idle = float(diff_vars[3]) / total * 100
    cpu_wait = float(diff_vars[4]) / total * 100
else:
    cpu_user = 0
    cpu_sys  = 0
    cpu_nice = 0
    cpu_idle = 0
    cpu_wait = 0

print 'user:%.2f nice:%.2f sys:%.2f idle:%.2f wait:%.2f' % (cpu_user, cpu_nice, cpu_sys, cpu_idle, cpu_wait), 
if param.perfdata:
    print ' | user=%.2f;;;; nice=%.2f;;;; sys=%.2f;;;; idle=%.2f;;;; wait=%.2f;;;;' % (cpu_user, cpu_nice, cpu_sys, cpu_idle, cpu_wait)
else:
    print ''

if param.zabbix:
    zabbix_api = ZabbixAPI(url='http://'+param.zabbix_server+'/zabbix/', user=param.zabbix_user, password=param.zabbix_pass)
    zabbix_key = re.sub('\..*$', '', re.sub('^.*/', r'', sys.argv[0]))
    #result = zapi.host.get(status=1)
    #hostnames = [host['host'] for host in result]
    #print hostnames
    packet = [
        ZabbixMetric(param.hostname, zabbix_key + '-user', cpu_user),
        ZabbixMetric(param.hostname, zabbix_key + '-sys', cpu_sys),
        ZabbixMetric(param.hostname, zabbix_key + '-nice', cpu_nice),
        ZabbixMetric(param.hostname, zabbix_key + '-wait', cpu_wait),
        ZabbixMetric(param.hostname, zabbix_key + '-idle', cpu_idle),
    ]
    result = ZabbixSender(use_config=False).send(packet)
    if param.isdebug:
        print result

sys.exit(0)

