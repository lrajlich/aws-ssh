#!/bin/bash

## Arguments
# host_xpath - sourced - from config
# aws_ssh_data_dir - sourced - computed runtime
# --refresh - parse
# --cached - parse

## Usage, display when
usage()
{
cat << EOF
Usage: aws-ssh ls [Options]
Display list of aws-servers. Potentially refresh listing with --refresh command
Options:
	-r --refresh       Optional. When set, pull new aws data
	-c --cached        Optional. When set, use cached data. This is the default behavor
	-d --details	Optional. Show details for the servers. Right now this is only the host
EOF
exit 1
}

## Parse arguments... Do manually since getopt is garbage and getopts doesn't support "long arguments"
refresh=0
details=0
while [ "$#" -gt "0" ]
do
    case $1 in
        ls)
            shift;;
        --help)
            usage;;
        -r | --refresh)
            refresh=1; shift;;
        -c | --cached)
            refresh=0; shift;;
	-d | --details)
	    details=1; shift;;
        *)
            echo "Not recognized command or option: $1"
            usage;;
        --) shift ; break ;;
    esac
done

mkdir -p ${aws_ssh_data_dir}
describe_instances_json=${aws_ssh_data_dir}/describe-instances.json
listing_file=${aws_ssh_data_dir}/listing

## Refresh automatically if we don't have a listing yet
if [ ! -e ${listing_file} ]; then
    refresh=1
fi

## Check to see if we should refresh data from Amazon and refresh if so
if [ ${refresh} -eq 1 ]; then
    echo "Refresh instance list from Amazon"

    aws ec2 describe-instances > ${describe_instances_json}

    instance_ids=`cat ${describe_instances_json} | jq '.Reservations[].Instances[].InstanceId' | sed  's/\"//g'`

    instance_names=""
    touch ${listing_file}.tmp
    for instance_id in $instance_ids;
    do
        host=`cat ${describe_instances_json} | jq ".Reservations[].Instances[] | select(.InstanceId==\"$instance_id\") | ${host_xpath}" | sed 's/\"//g'`
        name=`cat ${describe_instances_json} | jq ".Reservations[].Instances[] | select(.InstanceId==\"$instance_id\") | .Tags[] | select(.Key==\"Name\") | .Value" | sed 's/\"//g'`
        hostname=`cat ${describe_instances_json} | jq ".Reservations[].Instances[] | select(.InstanceId==\"$instance_id\") | .PrivateDnsName" | sed 's/\"//g' | sed 's/\..*//'`
        if [ -z $name ]; then
            name=${instance_id}
        fi
        if [ -z $instance_names ]; then
            instance_names=$name
        else
            instance_names="$name\n$instance_names"
        fi
        echo -e "$name\t${instance_id}\t${hostname}\t$host" >> ${listing_file}.tmp
    done

    mv ${listing_file}.tmp ${listing_file}

fi

if [ $details -eq 1 ]; then
	cat ${listing_file} | sort | echo -e "Name\tInstance_id\tHostname\tHost\n $(cat -)" |  column -t
else
	cat ${listing_file} | cut -f 1 | sort
fi

