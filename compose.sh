HOST_LOGS_DIR=`pwd`/data/logs
HOST_CONFIG_DIR=`pwd`/data/config
HOST_DATABASE_DIR=`pwd`/data/db
CONTAINER_NETWORK_NAME=container-monitoring-net # replace in yml file too


###
# Do not modify below entries, unless you know consequences.
###
CONTAINER_NETWORK_LIST=`docker network ls | grep $CONTAINER_NETWORK_NAME`;
if [ x"$CONTAINER_NETWORK_LIST" = x ]; then
	echo "Creating docker network: $CONTAINER_NETWORK_NAME" 
	docker network create $CONTAINER_NETWORK_NAME
fi

export CONTAINER_GRAFANA_HOME=/opt/grafana
export HOST_CONFIG_DIR_GRAFANA=$HOST_CONFIG_DIR/grafana
export HOST_DATABASE_DIR_GRAFANA=$HOST_DATABASE_DIR/grafana

export CONTAINER_INFLUXDB_HOME=/opt/influxdb
export HOST_LOGS_DIR_INFLUXDB=$HOST_LOGS_DIR/influxdb
export HOST_CONFIG_DIR_INFLUXDB=$HOST_CONFIG_DIR/influxdb
export HOST_DATABASE_DIR_INFLUXDB=$HOST_DATABASE_DIR/influxdb

export HOST_CONFIG_DIR_ICINGA2=$HOST_CONFIG_DIR/icinga2

docker-compose $*

unset CONTAINER_GRAFANA_HOME
unset HOST_CONFIG_DIR_GRAFANA
unset HOST_DATABASE_DIR_GRAFANA

unset CONTAINER_INFLUXDB_HOME
unset HOST_LOGS_DIR_INFLUXDB
unset HOST_CONFIG_DIR_INFLUXDB
unset HOST_DATABASE_DIR_INFLUXDB

unset HOST_CONFIG_DIR_ICINGA2
