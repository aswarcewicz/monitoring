#!/bin/bash

function checkDisk {
	disk=$1

	mountingPointsNumber=`echo "$disk" | wc -l`
	mountingPointsNumber=$(( $mountingPointsNumber-1 )) # remove header line from result

	for ((i=2;i<$mountingPointsNumber+2;i++));
	do
		mountingPointName[$(($i-2))]=`echo "$disk" | awk "NR==$i"'{print $6}'`
		mountingPointUsedPercent[$(($i-2))]=`echo "$disk" | awk "NR==$i"'{print $5}'`
		mountingPointUsedPercent[$(($i-2))]=`echo ${mountingPointUsedPercent[$(($i-2))]//%}` # remove % char
		mountingPointUsedMbytes[$(($i-2))]=`echo "$disk" | awk "NR==$i"'{print $3}'`
	done

	status="OK - warning/critical level not set|"
	statusCode=0

	for ((i=0;i<$mountingPointsNumber;i++))
	do
		status="$status${mountingPointName[$i]}_%=${mountingPointUsedPercent[$i]} ${mountingPointName[$i]}_mbytes=${mountingPointUsedMbytes[$i]} "
	done
	status=`echo $status | xargs` # trim whitespaces

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

disk=`ssh $user@$host $identfile 'df -mP'`

checkDisk "$disk" "$warning" "$critical"


