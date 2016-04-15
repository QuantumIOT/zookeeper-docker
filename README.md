# Zookeeper 3.5.1

This docker image allows to deploy a multi node Zookeeper cluster using dynamic host reconfiguration.

If an IP of a current existing node is provided the new instance will try to connect to the existing cluster.

Example command:

```
docker run --net host -d -p 2181:2181 -p 2888:2888 -p 3888:3888 --name [name] qiot/zookeeper [ip]
```