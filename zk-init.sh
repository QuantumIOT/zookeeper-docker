#!/bin/bash

ZK=$1
IPADDRESS=`ip -4 addr show scope global dev eth0 | grep inet | awk '{print \$2}' | cut -d / -f 1`
MYID=$(echo $IPADDRESS | sed 's/\.//g')

cd /opt/zookeeper
if [ -n "$ZK" ]
then
  /opt/zookeeper/bin/zkCli.sh -server $ZK:2181 get /zookeeper/config | grep ^server >> /opt/zookeeper/conf/zoo.cfg
  echo "server.$MYID=$IPADDRESS:2888:3888:observer;2181" >> /opt/zookeeper/conf/zoo.cfg
  cp /opt/zookeeper/conf/zoo.cfg /opt/zookeeper/conf/zoo.cfg.org
  /opt/zookeeper/bin/zkServer-initialize.sh --force --myid=$MYID
  ZOO_LOG_DIR=/var/log ZOO_LOG4J_PROP='INFO,CONSOLE,ROLLINGFILE' /opt/zookeeper/bin/zkServer.sh start-foreground
  sleep 10
  /opt/zookeeper/bin/zkCli.sh -server $ZK:2181 reconfig -add "server.$MYID=$IPADDRESS:2888:3888:participant;2181"
else
  echo "server.$MYID=$IPADDRESS:2888:3888;2181" >> /opt/zookeeper/conf/zoo.cfg
  /opt/zookeeper/bin/zkServer-initialize.sh --force --myid=$MYID
  ZOO_LOG_DIR=/var/log ZOO_LOG4J_PROP='INFO,CONSOLE,ROLLINGFILE' /opt/zookeeper/bin/zkServer.sh start-foreground
fi
