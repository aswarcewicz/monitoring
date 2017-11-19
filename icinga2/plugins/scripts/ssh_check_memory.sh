#!/bin/bash

function checkMemory() {
	memInfo=$1
	readarray -td, warning <<<"$2"
	readarray -td, critical <<<"$3"
	memTotalInKB=`echo "$memInfo" | grep "^MemTotal" | awk '{print $2}'`
	memFree=`echo "$memInfo" | grep "^MemFree" | awk '{print $2}'`
	cached=`echo "$memInfo" | grep "^Cached" | awk '{print $2}'`
	memoryFreeInKB=$(($memFree + $cached))
	memoryUsedInKB=$(($memTotalInKB - $memoryFreeInKB))

	memoryFreeInMB=$(($memoryFreeInKB / 1024))
	memoryUsedInMB=$(($memoryUsedInKB / 1024))

	memUsedPercent=$(($memoryUsedInKB * 100 / $memTotalInKB))
	memFreePercent=$((100 - $memUsedPercent))

	swapTotalInKB=`echo "$memInfo" | grep "^SwapTotal" | awk '{print $2}'`
	swapFree=`cat /proc/meminfo | grep "^SwapFree" | awk '{print $2}'`
	swapCached=`cat /proc/meminfo | grep "^SwapCached" | awk '{print $2}'`
	swapFreeInKB=$(($swapFree + $swapCached))
	swapUsedInKB=$(($swapTotalInKB - $swapFreeInKB))

	swapFreeInMB=$(($swapFreeInKB / 1024))

	swapUsedInMB=$(($swapUsedInKB / 1024))


	swapUsedPercent=0
	if [ $swapTotalInKB -gt "0" ]; then 
		swapUsedPercent=$(($swapUsedInKB * 100 / $swapTotalInKB))
	fi
	swapFreePercent=$((100 - $swapUsedPercent))

	status="OK - warning/critical level not set"
	statusCode=0
	status="$status|memoryFreeMbytes=$memoryFreeInMB memoryFreePercent=$memFreePercent memoryUsedMbytes=$memoryUsedInMB memoryUsedPercent=$memUsedPercent swapFreeMbytes=$swapFreeInMB swapFreePercent=$swapFreePercent swapUsedMbytes=$swapUsedInMB swapUsedPercent=$swapUsedPercent"
	
	echo $status
	return $statusCode
}

# parsing arguments
identfile=""
user=""
host=""
warning=""
critical=""
while [ $# -ge 1 ]; do
        case "$1" in
                --)
                    # No more options left
                    shift
                    break
                   ;;
                -i)
                        identfile="-i $2"
                        shift
                        ;;
                -u)
                        user="$2"
                        shift
                        ;;
		-w)
                        warning="$2"
                        shift
                        ;;
		-c)
                        critical="$2"
                        shift
                        ;;
		-h)
			host="$2"
			shift
			;;
		*)
			if [[ -z $host ]]; then
				host="$1"
			fi
			;;
        esac
        shift
done
if [ -z "$user" ] || [ -z "$host" ]; then
	echo "Username and Host are required."
	exit -1
fi 

memInfo=`ssh $user@$host $identfile 'cat /proc/meminfo'`

checkMemory "$memInfo" "$warning" "$critical"
