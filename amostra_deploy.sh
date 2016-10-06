#!/bin/bash

#  deploy.sh
#  
#
#  Created by Arman Arkilic on 10/3/16.
#
# Run as root
# sudo su

export HOSTNAME='xf23id-ca.cs.nsls2.local'

# Get the necessary debian packages
apt-get install sysv-rc-softioc

export http_proxy=http://proxy:8888
export https_proxy=http://proxy:8888

# Create conda env
conda create -p /opt/conda_envs/services python=3.5
source activate services
conda install amostra
# conda install pymongo ujson tornado jsonschema yaml pytz doct
# pip install requests


# Create necessary directories for ioc
mkdir /services
cd /services
mkdir -p /epics/iocs/
cd /services/
git clone https://github.com/NSLS-II/amostra
mkdir -p /epics/iocs/amostra/
cd /epics/iocs/amostra

# Startup script
echo "NAME=amostra
PORT=4055
HOST=$HOSTNAME
USER=tornado" > config
echo '#!/bin/bash
export PATH=/opt/conda/bin:$PATH
source activate services
python /services/amostra/startup.py --mongo-host=localhost --mongo-port=27017 --database=amostra --service-port=7772 --timezone=US/Eastern' > launch.sh
ln -s -T launch.sh st.cmd

chown -R tornado:tornado /epics/iocs/amostra

# Fix permissions
find /opt/conda -type d -execdir chmod og+x {} +
chmod -R a+r /opt/conda

find /opt/conda_envs -type d -execdir chmod og+x {} +
chmod -R a+r /opt/conda_envs

manage-iocs install amostra
manage-iocs enable amostra

chmod 755 st.cmd
chmod 755 launch.sh
chmod 755 config

/etc/init.d/softioc-amostra start

# Then it should yield to something like below once you telnet in:

#
#tornado@xf23id-ca:/home/arkilic$ telnet localhost 4055
#Trying ::1...
#Trying 127.0.0.1...
#Connected to localhost.
#Escape character is '^]'.
#@@@ Welcome to procServ (procServ Process Server 2.6.0)
#@@@ Use ^X to kill the child, auto restart is ON, use ^T to toggle auto restart
#@@@ procServ server PID: 30815
#@@@ Server startup directory: /epics/iocs/amostra
#@@@ Child startup directory: /epics/iocs/amostra
#@@@ Child "amostra" started as: /epics/iocs/amostra/st.cmd
#@@@ Child "amostra" PID: 30821
#@@@ procServ server started at: Mon Oct  3 10:53:23 2016
#@@@ Child "amostra" started at: Mon Oct  3 10:53:24 2016
#@@@ 0 user(s) and 0 logger(s) connected (plus you)
#WARNING:tornado.access:404 GET / (10.23.0.8) 2.27ms
#WARNING:tornado.access:404 GET /favicon.ico (10.23.0.8) 0.62ms
#WARNING:tornado.access:404 GET /favicon.ico (10.23.0.8) 0.46ms



# List of archiver machines as of 10/5/2016:
# root@ns0:/var/lib/named/var/cache/bind# grep '\-ca[^m]' *.sub|grep -v '\-rsc\|\-cada'
# s1030.cs.nsls2.local.sub:xf03id-ca1             A       10.3.0.5
# s1050.cs.nsls2.local.sub:xf05id-ca1             A       10.5.0.4
# s1100.cs.nsls2.local.sub:xf10id-ca1             A       10.10.0.4
# s1110.cs.nsls2.local.sub:xf11id-ca              A       10.11.0.9
# s1150.cs.nsls2.local.sub:xf11bm-ca1             A       10.11.128.4
# s1210.cs.nsls2.local.sub:xf12id-ca1             A       10.12.0.3
# s1230.cs.nsls2.local.sub:xf23id-ca              A       10.23.0.8
# s1280.cs.nsls2.local.sub:xf28id-ca1             A       10.28.0.5
# s1610.cs.nsls2.local.sub:xf16idc-ca             A       10.16.0.3
# s1710.cs.nsls2.local.sub:xf17id1-ca1            A       10.17.0.3
# s1720.cs.nsls2.local.sub:xf17id2-ca1            A       10.17.32.3
# s1750.cs.nsls2.local.sub:xf17bm-ca1             CNAME   xf17bm-ioc1
# s210.cs.nsls2.local.sub:xf02id1-ca1             A       10.2.0.4
# s2110.cs.nsls2.local.sub:xf21id1-ca1            A       10.21.0.3
# s410.cs.nsls2.local.sub:xf04id-ca1              A       10.4.0.3
# s810.cs.nsls2.local.sub:xf08id-ca1              A       10.8.0.5
# s850.cs.nsls2.local.sub:xf08bm-ca1              A       10.8.128.2
