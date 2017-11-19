FROM ubuntu

ARG DOCKER_INFLUXDB_HOME
ARG INFLUXDB_VERSION
ARG INFLUXDB_DIR_NAME_INSIDE_TAR

RUN apt-get update && \
    apt-get install -y wget && \
    apt-get clean -y && \

    # download influxdb
    wget -q --no-check-certificate --no-cookies https://dl.influxdata.com/influxdb/releases/influxdb-${INFLUXDB_VERSION}_linux_amd64.tar.gz  -P /tmp/influxdb && \
    tar -xzf /tmp/influxdb/influxdb-${INFLUXDB_VERSION}_linux_amd64.tar.gz  -C /tmp/influxdb && \
    mkdir -p ${DOCKER_INFLUXDB_HOME} && \
    mv /tmp/influxdb/${INFLUXDB_DIR_NAME_INSIDE_TAR}/* ${DOCKER_INFLUXDB_HOME} && \
    rm -R /tmp/influxdb

WORKDIR ${DOCKER_INFLUXDB_HOME}

RUN	cp -R etc/influxdb conf-original && \
	echo '#!/bin/bash' >> start.sh && \
	echo 'if [ -z "$(ls -A conf)" ]; then' >>start.sh && \
    	echo 'cp -r conf-original/* etc/influxdb' >> start.sh && \
	echo 'fi' >> start.sh && \
	echo 'exec usr/bin/influxd -config etc/influxdb/influxdb.conf' >> start.sh && \
	chmod +x start.sh

ENV INFLUXDB_HOME=${DOCKER_INFLUXDB_HOME}

EXPOSE 8086
