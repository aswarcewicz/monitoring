FROM ubuntu

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y --no-install-recommends wget software-properties-common openssh-client && \
    wget -q --no-check-certificate --no-cookies -O - http://packages.icinga.org/icinga.key | apt-key add - && \
    add-apt-repository 'deb http://packages.icinga.org/ubuntu icinga-xenial main' && \
    apt-get update && \
    apt-get install icinga2 nagios-plugins -y &&  \
    apt-get clean -y && \
    icinga2 feature enable influxdb && \
    icinga2 feature disable notification && \
    /etc/init.d/icinga2 start && \
    /etc/init.d/icinga2 stop

COPY ./plugins/scripts/* /usr/lib/nagios/plugins/scripts/
COPY ./commands/* /etc/icinga2/conf.d/commands/
COPY ./services/* /etc/icinga2/conf.d/services/

COPY ./ssh_keys/* /var/lib/nagios/.ssh/

RUN chown -R nagios:nagios /var/lib/nagios/.ssh && \
    cp -R /etc/icinga2 /etc/icinga2-original && \
    echo 'Host *' >> /etc/ssh/ssh_config && \
    echo 'StrictHostKeyChecking no' >> /etc/ssh/ssh_config && \
    echo 'UserKnownHostsFile=/dev/null' >> /etc/ssh/ssh_config && \
    echo 'LogLevel ERROR' >> /etc/ssh/ssh_config && \

    echo '#!/bin/bash' >> start.sh && \
    echo 'if [ -z "$(ls -A /etc/icinga2)" ]; then' >> start.sh && \
    echo 'cp -r /etc/icinga2-original/* /etc/icinga2' >> start.sh && \
    echo 'fi' >> start.sh && \
    echo 'exec /usr/sbin/icinga2 daemon' >> start.sh && \
    chmod +x start.sh


