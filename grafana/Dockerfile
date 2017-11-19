FROM ubuntu

ARG DOCKER_GRAFANA_HOME
ARG GRAFANA_VERSION

RUN apt-get update && \
    apt-get install -y wget && \
    apt-get clean -y && \

    # download grafana
    wget -q --no-check-certificate --no-cookies https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-${GRAFANA_VERSION}.linux-x64.tar.gz  -P /tmp/grafana && \
    tar -xzf /tmp/grafana/grafana-${GRAFANA_VERSION}.linux-x64.tar.gz -C /tmp/grafana && \
    mkdir -p ${DOCKER_GRAFANA_HOME} && \
    mv /tmp/grafana/grafana-${GRAFANA_VERSION}/* ${DOCKER_GRAFANA_HOME} && \
    rm -R /tmp/grafana

WORKDIR ${DOCKER_GRAFANA_HOME}

RUN	cp -R conf conf-original && \
	echo '#!/bin/bash' >> start.sh && \
	echo 'if [ -z "$(ls -A conf)" ]; then' >>start.sh && \
    	echo 'cp -r conf-original/* conf' >> start.sh && \
	echo 'fi' >> start.sh && \
	echo 'exec bin/grafana-server' >> start.sh && \
	chmod +x start.sh

ENV GRAFANA_HOME=${DOCKER_GRAFANA_HOME}

EXPOSE 3000
