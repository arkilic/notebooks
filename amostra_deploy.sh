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