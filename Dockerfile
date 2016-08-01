FROM java:openjdk-8-jre-alpine

ARG MIRROR=http://apache.mirrors.pair.com
ARG VERSION=3.5.2-alpha

LABEL name="zookeeper" version=$VERSION

RUN apk add --no-cache wget bash \
    && mkdir /opt \
    && wget -q -O - $MIRROR/zookeeper/zookeeper-$VERSION/zookeeper-$VERSION.tar.gz | tar -xzf - -C /opt \
    && mv /opt/zookeeper-$VERSION /opt/zookeeper \
    && mkdir -p /tmp/zookeeper

WORKDIR /opt/zookeeper

ADD zoo.cfg /opt/zookeeper/conf/
ADD zk-init.sh /usr/local/bin/

EXPOSE 2181 2888 3888

VOLUME ["/opt/zookeeper/conf", "/tmp/zookeeper"]

ENTRYPOINT ["/usr/local/bin/zk-init.sh"]
