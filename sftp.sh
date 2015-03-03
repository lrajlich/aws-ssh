#!/bin/bash

## Arguments
# aws_ssh_data_dir - sourced (runtime)
# instance_name - sourced (runtime, commandline argument)
# user - sourced (config)
# pem -sourced (config)


echo "Connect to host..."
cat ${aws_ssh_data_dir}/listing | grep "${instance_name}\s" 

num_lines=$(cat ${aws_ssh_data_dir}/listing | grep "${instance_name}\s" | wc -l)
if [ ${num_lines} -eq 0 ]; then
	echo "No host matches. Exit."
	exit 1
fi

if [ ${num_lines} -gt 1 ]; then
	echo "More than 1 host matches. Exit."
	exit 1
fi

host=$(cat ${aws_ssh_data_dir}/listing | grep "${instance_name}\s" | cut -f 3)
sftp -o IdentityFile=${pem} ${user}@${host}
