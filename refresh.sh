#!/bin/bash

## Arguments
# host_xpath - sourced - from config
# aws_ssh_data_dir - sourced - computed runtime

mkdir -p ${aws_ssh_data_dir}

describe_instances_json=${aws_ssh_data_dir}/describe-instances.json
listing_file=${aws_ssh_data_dir}/listing

aws ec2 describe-instances > ${describe_instances_json}
instance_ids=`cat ${describe_instances_json} | jq '.Reservations[].Instances[].InstanceId' | sed  's/\"//g'`

instance_names=""
touch ${listing_file}.tmp
for instance_id in $instance_ids;
do
	host=`cat ${describe_instances_json} | jq ".Reservations[].Instances[] | select(.InstanceId==\"$instance_id\") | ${host_xpath}" | sed 's/\"//g'`
	name=`cat ${describe_instances_json} | jq ".Reservations[].Instances[] | select(.InstanceId==\"$instance_id\") | .Tags[] | select(.Key==\"Name\") | .Value" | sed 's/\"//g'`
	if [ -z $instance_names ]; then
		instance_names=$name
	else
		instance_names="$name\n$instance_names"
	fi
	echo $name=$host >> ${listing_file}.tmp
done

echo -e $instance_names | sort

mv ${listing_file}.tmp ${listing_file}

