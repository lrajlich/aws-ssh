#!/bin/bash

## Arguments
# host_xpath - sourced - from config
# aws_ssh_data_dir - sourced - computed runtime

mkdir -p ${aws_ssh_data_dir}

describe_instances_json=${aws_ssh_data_dir}/describe-instances.json
listing_file=${aws_ssh_data_dir}/listing

aws ec2 describe-instances > ${describe_instances_json}
instances=`cat ${describe_instances_json} | jq '.Reservations[].Instances[].InstanceId' | sed  's/\"//g'`

rm -f ${listing_file}
for instance_id in $instances;
do
	host=`cat ${describe_instances_json} | jq ".Reservations[].Instances[] | select(.InstanceId==\"$instance_id\") | ${host_xpath}" | sed 's/\"//g'`
	name=`cat ${describe_instances_json} | jq ".Reservations[].Instances[] | select(.InstanceId==\"$instance_id\") | .Tags[] | select(.Key==\"Name\") | .Value" | sed 's/\"//g'`
	echo $name
	echo $name=$host >> ${listing_file}
done

