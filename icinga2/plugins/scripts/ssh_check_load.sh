#!/bin/bash

function checkLoad {
	uptime=$1
	readarray -td, warning <<<"$2"
	readarray -td, critical <<<"$3"

	decimalPoint=`locale decimal_point`
	load=($(echo $uptime | grep -o 'load average\: .*' | grep -o "[0-9]\+$decimalPoint[0-9]\+"))
	load1=`echo ${load[0]} | tr $decimalPoint .`
	load5=`echo ${load[1]} | tr $decimalPoint .`
	load15=`echo ${load[2]} | tr $decimalPoint .`

	if [ "${#warning[@]}" -eq "3" ] && [ "${#critical[@]}" -eq "3" ]; then
		todo=1
	else
		todo=1
	fi

	status="OK - warning/critical level not set"
	statusCode=0
	status="$status|load1=$load1 load5=$load5 load15=$load15"

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

uptime=`ssh $user@$host $identfile 'uptime'`

checkLoad "$uptime" "$warning" "$critical"


