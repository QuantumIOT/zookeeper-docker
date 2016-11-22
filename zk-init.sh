#!/bin/sh

set -e

if [ -f "/etc/zookeeper/conf/zoo.cfg" ]; then
    echo "Zookeeper configuration file found in /etc/zookeeper/conf/zoo.cfg"
else
    if [ -z "${ZK_CONFIG}" ]; then
        echo "Zookeeper config not found, here are the options:"
        echo "  - bind-mount /etc/zookeeper/conf/zoo.cfg"
        echo "  - specify ZK_CONFIG env variable with config values"
        exit 1
    fi

    echo "dataDir=/var/lib/zookeeper" > "/etc/zookeeper/conf/zoo.cfg"

    for line in $(echo "${ZK_CONFIG}" | tr "," "\n"); do
        echo "$line" >> "/etc/zookeeper/conf/zoo.cfg"
    done
fi

if [ -e "/var/lib/zookeeper/myid" ]; then
    echo "Zookeeper node id found in /var/lib/zookeeper/myid"
else
    if [ -z "${ZK_ID}" ]; then
        echo "zookeeper node id not found, here are your options:"
        echo "  - bind-mount /var/lib/zookeeper with myid"
        echo "  - specify ZK_ID env variable with id"
        exit 1
    fi

    echo "${ZK_ID}" > "/var/lib/zookeeper/myid"
fi

exec /usr/share/zookeeper/bin/zkServer.sh start-foreground
