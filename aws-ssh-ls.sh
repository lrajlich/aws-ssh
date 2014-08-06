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
	--refresh       Optional. When set, pull new aws data
	--cached        Optional. When set, use cached data. This is the default behavor
EOF
exit 1
}

## Parse arguments... Do manually since getopt is garbage and getopts doesn't support "long arguments"
refresh=0
while [ "$#" -gt "0" ]
do
    case $1 in
        ls)
            shift;;
        --help)
            usage;;
        --refresh)
            refresh=1; shift;;
        --cached)
            refresh=0; shift;;
        *)
            echo "Not recognized command or option: $1"
            usage;;
        --) shift ; break ;;
    esac
done

mkdir -p ${aws_ssh_data_dir}
describe_instances_json=${aws_ssh_data_dir}/describe-instances.json
listing_file=${aws_ssh_data_dir}/listing

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
        if [ -z $name ]; then
            name=${instance_id}
        fi
        if [ -z $instance_names ]; then
            instance_names=$name
        else
            instance_names="$name\n$instance_names"
        fi
        echo $name=$host >> ${listing_file}.tmp
    done

    mv ${listing_file}.tmp ${listing_file}

fi

cat ${listing_file} | cut -f 1 -d "=" | sort

